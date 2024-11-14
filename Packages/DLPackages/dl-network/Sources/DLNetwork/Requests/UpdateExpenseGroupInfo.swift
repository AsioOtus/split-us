import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct UpdateExpenseGroupInfo: ModellableResponseRequest {
		public typealias Body = UpdateExpenseGroupInfoRequestModel
		public typealias ResponseModel = SharedResponseModels.ExpenseInfo
		
		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.post)
			.setPath("expenses/updateExpenseGroupInfo")
		}

		public var body: Body?
		
		public init (
			expenseGroupInfo: ExpenseInfo,
			expenseGroupId: UUID
		) {
			self.body = .init(
				expenseGroupId: expenseGroupId,
				expenseGroupInfo: expenseGroupInfo
			)
		}
	}
}
