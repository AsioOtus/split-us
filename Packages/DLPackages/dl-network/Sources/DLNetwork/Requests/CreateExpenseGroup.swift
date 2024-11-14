import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct CreateExpenseGroup: ModellableResponseRequest {
		public typealias Body = CreateExpenseGroupRequestModel
		public typealias ResponseModel = SharedResponseModels.ExpenseGroup
		
		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.post)
			.setPath("expenses/createExpenseGroup")
		}

		public var body: Body?
		
		public init (
			expenseGroupContainer: ExpenseGroup.New.Container,
			superExpenseGroupId: UUID?,
			userGroupId: UUID
		) {
			self.body = .init(
				expenseGroupContainer: expenseGroupContainer,
				superExpenseGroupId: superExpenseGroupId,
				userGroupId: userGroupId
			)
		}
	}
}
