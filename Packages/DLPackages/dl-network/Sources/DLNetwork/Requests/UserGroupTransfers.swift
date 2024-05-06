import Foundation
import NetworkUtil

extension Requests {
	public struct UserGroupTransfers: ModellableResponseRequest {
		public typealias Body = UserGroupTransfersRequestModel
		public typealias ResponseModel = UserGroupTransfersResponseModel

		public var method: HTTPMethod { .post }
		public var path: String { "userGroup/transfers" }
		public var body: Body?

		public init (userGroupId: UUID) {
			self.body = .init(userGroupId: userGroupId)
		}
	}
}
