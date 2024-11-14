import NetworkUtil
import Combine
import Foundation

public protocol ModellableResponseRequest: Request {
	associatedtype ResponseModel: Codable
}

public extension ModellableResponseRequest {
	var body: Data? { nil }
}

public extension NetworkController {
	func send <RQ: ModellableResponseRequest> (
		_ request: RQ,
		delegate: some NetworkControllerSendingDelegate<RQ, Envelope<RQ.ResponseModel>>,
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> StandardResponse<Envelope<RQ.ResponseModel>> {
		try await send(
			request,
			response: StandardResponse<Envelope<RQ.ResponseModel>>.self,
			delegate: delegate,
			configurationUpdate: configurationUpdate
		)
	}

	func send <RQ: ModellableResponseRequest> (
		_ request: RQ,
		configurationUpdate: RequestConfiguration.Update? = nil
	) async throws -> StandardResponse<Envelope<RQ.ResponseModel>> {
		try await send(
			request,
			response: StandardResponse<Envelope<RQ.ResponseModel>>.self,
			delegate: .standard(),
			configurationUpdate: configurationUpdate
		)
	}
}
