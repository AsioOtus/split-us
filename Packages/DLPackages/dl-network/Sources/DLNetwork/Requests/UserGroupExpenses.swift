import Foundation
import NetworkUtil

extension Requests {
	public struct UserGroupExpenses: ModellableResponseRequest {
		public typealias Body = UserGroupExpensesRequestModel
		public typealias ResponseModel = UserGroupExpensesResponseModel

		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.post)
			.setPath("userGroup/expenses")
		}

		public var body: Body?

		public init (userGroupId: UUID) {
			self.body = .init(userGroupId: userGroupId)
		}
	}
}
