import Dependencies
import DLNetwork
import Foundation
import ILDebug
import Multitool
import NetworkUtil

extension Debug {
	struct AuthenticatedNetworkControllerDecorator: NetworkControllerDecorator {
		static let authorizedOstap = Self(userId: .create(1, 1))

		@Dependency(\.networkController) var networkController

		let userId: UUID

		func send <RQ: Request, RS: Response> (
			_ request: RQ,
			response: RS.Type,
			delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
			configurationUpdate: RequestConfiguration.Update?
		) async throws -> RS {
			try await networkController.send(request, response: response, delegate: delegate) {
				$0
					.addHeader(key: "debug-auth", value: userId.description)
					.update(configurationUpdate)
			}
		}
	}
}
