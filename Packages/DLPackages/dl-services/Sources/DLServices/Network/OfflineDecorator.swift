import NetworkUtil
import Foundation

struct OfflineDecorator: NetworkControllerDecorator {
	let networkController: NetworkController

	func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> RS {
		if UserDefaults.standard.bool(forKey: "sco.debug.isOfflineMode") {
			throw URLError(.notConnectedToInternet)
		}

		return try await networkController.send(
			request,
			response: response,
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}
}

extension NetworkController {
	func offline () -> OfflineDecorator {
		.init(networkController: self)
	}
}
