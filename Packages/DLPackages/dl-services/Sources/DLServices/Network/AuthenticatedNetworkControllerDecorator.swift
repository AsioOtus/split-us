import Dependencies
import DLNetwork
import DLErrors
import Foundation
import NetworkUtil

public struct AuthenticatedNetworkControllerDecorator: NetworkControllerDecorator {
	@Dependency(\.authorizationService) var authorizationService
	@Dependency(\.backendErrorValidationService) var backendErrorValidationService
	@Dependency(\.localAuthorizationService) var localAuthorizationService
	@Dependency(\.networkConnectivityService) var networkConnectivityService
	@Dependency(\.logoutEventChannel) var logoutEventChannel
	@Dependency(\.tokensValidationService) var tokensValidationService

	public let networkController: NetworkController

	init (networkController: NetworkController) {
		self.networkController = networkController
	}

	public func send <RQ: Request, RS: Response>(
		_ request: RQ,
		response: RS.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> RS {
		guard
			var tokenPair = try? localAuthorizationService.savedTokenPair(),
			let userId = tokensValidationService.userId(from: tokenPair)
		else {
			await logoutEventChannel.send(.logout(.noLocalAuthData))
			throw AuthorizationError.noValidAuthData
		}

		do {
			if tokensValidationService.isAccessTokenNearlyExpired(tokenPair: tokenPair) {
				tokenPair = try await authorizationService.reauthenticate(refreshToken: tokenPair.refresh, userId: userId)
				try localAuthorizationService.saveTokenPair(tokenPair)
			}
		} catch let error as OfflineTriggerError {
			throw error
		} catch {
			if backendErrorValidationService.isAuthenticationError(error) {
				await logoutEventChannel.send(.logout(.authenticationFailed))
			}
			
			throw error
		}

		do {
			return try await networkController.send(request, response: response, delegate: delegate) {
				$0
					.addHeader(key: "Authorization", value: "Bearer \(tokenPair.access)")
					.update(configurationUpdate)
			}
		} catch {
			if backendErrorValidationService.isAuthenticationError(error) {
				await logoutEventChannel.send(.logout(.authenticationFailed))
			}

			throw error
		}
	}
}

public extension NetworkController {
	func authenticated () -> AuthenticatedNetworkControllerDecorator {
		.init(networkController: self)
	}
}
