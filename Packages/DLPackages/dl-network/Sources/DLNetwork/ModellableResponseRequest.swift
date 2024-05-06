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
		encoding: ((RQ.Body) throws -> Data)? = nil,
		decoding: ((Data) throws -> StandardResponse<Envelope<RQ.ResponseModel>>.Model)? = nil,
		configurationUpdate: URLRequestConfiguration.Update = { $0 },
		interception: @escaping URLRequestInterception = { $0 }
	) async throws -> StandardResponse<Envelope<RQ.ResponseModel>> {
		try await send(
			request,
			response: StandardResponse<Envelope<RQ.ResponseModel>>.self,
			encoding: encoding,
			decoding: decoding,
			configurationUpdate: configurationUpdate,
			interception: interception
		)
	}
}
