import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct DeleteExpense: ModellableResponseRequest {
		public typealias Body = SharedRequestModels.DeleteExpenseTree
		public typealias ResponseModel = SharedResponseModels.Success

		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.delete)
			.setPath("expenses/deleteExpense")
		}

		public var body: Body?

		public init (_ body: Body) {
			self.body = body
		}
	}
}

public extension Requests.DeleteExpense {
	init (expenseId: UUID) {
		self.init(.init(expenseTreeId: expenseId))
	}
}
