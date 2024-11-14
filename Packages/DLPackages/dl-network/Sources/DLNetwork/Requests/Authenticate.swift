import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct Authenticate: ModellableResponseRequest {
		public typealias Body = AuthenticateRequestModel
		public typealias ResponseModel = AuthenticateResponseModel
		
		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.post)
			.setPath("auth/authenticate")
		}

		public let body: Body?

		public init (_ body: Body) {
			self.body = body
		}
	}
}

public extension Requests.Authenticate {
	init (
		username: String,
		password: String
	) {
		self.body = .init(
			username: username,
			password: password
		)
	}
}
