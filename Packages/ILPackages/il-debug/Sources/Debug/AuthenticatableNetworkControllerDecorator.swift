import Dependencies
import DLNetwork
import Foundation
import NetworkUtil

extension Debug {
	struct AuthenticatedNetworkControllerDecorator: FullScaleNetworkControllerDecorator {
		static let authorizedOstap = Self(userId: .create(1, 1))
		
		@Dependency(\.networkController) var networkController
		
		let userId: UUID
		
		func send<RQ, RS>(
			_ request: RQ,
			response: RS.Type,
			encoding: ((RQ.Body) throws -> Data)? = nil,
			decoding: ((Data) throws -> RS.Model)? = nil,
			configurationUpdate: URLRequestConfiguration.Update = { $0 },
			interception: @escaping URLRequestInterception = { $0 }
		) async throws -> RS where RQ: NetworkUtil.Request, RS: NetworkUtil.Response {
			try await networkController
				.send(
					request,
					response: response,
					encoding: encoding,
					decoding: decoding,
					configurationUpdate: {
						$0
							.addHeader(key: "debug-auth", value: userId.description)
							.addHeader(key: "Content-Type", value: "application/json; charset=utf-8")
					},
					interception: interception
				)
		}
	}
	
}
