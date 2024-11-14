import Foundation
import NetworkUtil

extension Requests {
	public struct UserGroupUsers: ModellableResponseRequest {
		public typealias Body = UserGroupUsersRequestModel
		public typealias ResponseModel = UserGroupUsersResponseModel
		
		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.post)
			.setPath("userGroup/users")
		}

		public let body: Body?
		
		public init (body: Body) {
			self.body = body
		}
	}
}
