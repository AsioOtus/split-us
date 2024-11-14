import Foundation
import NetworkUtil

extension Requests {
	public struct UserDetails: ModellableResponseRequest {
		public typealias Body = UserDetailsRequestModel
		public typealias ResponseModel = UserDetailsResponseModel

		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.post)
			.setPath("users/userDetails")
		}

		public let body: Body?

		public init (body: Body) {
			self.body = body
		}
	}
}
