import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct DeleteExpenseGroup: ModellableResponseRequest {
		public typealias Body = SharedRequestModels.DeleteExpenseTree
		public typealias ResponseModel = SharedResponseModels.Success

		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.delete)
			.setPath("expenses/deleteExpenseGroup")
		}

		public var body: Body?

		public init (_ body: Body) {
			self.body = body
		}
	}
}

public extension Requests.DeleteExpenseGroup {
	init (expenseGroupId: UUID) {
		self.init(.init(expenseTreeId: expenseGroupId))
	}
}
