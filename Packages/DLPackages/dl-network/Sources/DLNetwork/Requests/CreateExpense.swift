import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct CreateExpense: ModellableResponseRequest {
		public typealias Body = CreateExpenseRequestModel
		public typealias ResponseModel = SharedResponseModels.Expense
		
		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.post)
			.setPath("expenses/createExpense")
		}

		public var body: Body?
		
		public init (
			expense: Expense.New,
			superExpenseGroupId: UUID?,
			userGroupId: UUID
		) {
			self.body = .init(
				expense: expense,
				superExpenseGroupId: superExpenseGroupId,
				userGroupId: userGroupId
			)
		}
	}
}
