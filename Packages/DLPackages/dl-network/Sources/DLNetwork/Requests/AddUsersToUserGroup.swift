import Foundation
import NetworkUtil

extension Requests {
	public struct AddUserToUserGroup: ModellableResponseRequest {
		public typealias Body = AddUserToUserGroupRequestModel
		public typealias ResponseModel = SharedResponseModels.Success

		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.post)
			.setPath("userGroup/addUsers")
		}

		public var body: Body?

		public init (body: Body) {
			self.body = body
		}
	}
}
