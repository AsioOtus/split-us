import Dependencies
import DLNetwork
import DLErrors
import Foundation
import NetworkUtil

public struct NetworkConnectivityControllerDecorator: NetworkControllerDecorator {
	@Dependency(\.networkConnectivityService) var networkConnectivityService

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
		do {
			let response = try await networkController.send(
				request,
				response: response,
				delegate: delegate,
				configurationUpdate: configurationUpdate
			)

			networkConnectivityService.updateState(.online)

			return response
		} catch {
			let newState = networkConnectivityService.updateState(error: error)

			if newState.isOffline {
				throw OfflineTriggerError(error: error)
			} else {
				throw error
			}
		}
	}
}

public extension NetworkController {
	func networkConnectivity () -> NetworkConnectivityControllerDecorator {
		.init(networkController: self)
	}
}
