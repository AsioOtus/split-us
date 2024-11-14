import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct UpdateExpense: ModellableResponseRequest {
		public typealias Body = UpdateExpenseRequestModel
		public typealias ResponseModel = SharedResponseModels.Expense

		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.post)
			.setPath("expenses/updateExpense")
		}

		public var body: Body?

		public init (
			expense: Expense.Update
		) {
			self.body = .init(expense: expense)
		}
	}
}
