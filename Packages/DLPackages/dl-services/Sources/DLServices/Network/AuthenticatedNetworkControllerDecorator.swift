import Dependencies
import DLNetwork
import DLErrors
import Foundation
import NetworkUtil

struct AuthenticatedNetworkControllerDecorator: FullScaleNetworkControllerDecorator {
	@Dependency(\.authorizationService) var authorizationService
	@Dependency(\.localAuthorizationService) var localAuthorizationService
	@Dependency(\.tokensValidationService) var tokensValidationService
	@Dependency(\.networkController) var networkController

	func send<RQ, RS>(
		_ request: RQ,
		response: RS.Type,
		encoding: ((RQ.Body) throws -> Data)? = nil,
		decoding: ((Data) throws -> RS.Model)? = nil,
		configurationUpdate: URLRequestConfiguration.Update = { $0 },
		interception: @escaping URLRequestInterception = { $0 }
	) async throws -> RS where RQ: NetworkUtil.Request, RS: NetworkUtil.Response {
		guard
			var tokenPair = try? localAuthorizationService.savedTokenPair(),
			let userId = tokensValidationService.userId(from: tokenPair)
		else { throw AuthorizationError.noValidAuthData }

		if tokensValidationService.isAccessTokenNearlyExpired(tokenPair: tokenPair) {
			tokenPair = try await authorizationService.reauthenticate(refreshToken: tokenPair.refresh, userId: userId)
			try localAuthorizationService.saveTokenPair(tokenPair)
		}

		return try await networkController
			.send(
				request,
				response: response,
				encoding: encoding,
				decoding: decoding,
				configurationUpdate: {
					$0.addHeader(key: "Authorization", value: "Bearer \(tokenPair.access)")
				},
				interception: interception
			)
	}
}

public struct AuthenticatedNetworkControllerDependecncyKey: DependencyKey {
	public static var liveValue: NetworkController {
		AuthenticatedNetworkControllerDecorator()
	}
}

public extension DependencyValues {
	var authenticatedNetworkController: NetworkController {
		get { self[AuthenticatedNetworkControllerDependecncyKey.self] }
		set { self[AuthenticatedNetworkControllerDependecncyKey.self] = newValue }
	}
}
