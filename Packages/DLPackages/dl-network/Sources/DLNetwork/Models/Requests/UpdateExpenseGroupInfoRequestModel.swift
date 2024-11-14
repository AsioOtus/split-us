import DLModels
import Foundation

public struct UpdateExpenseGroupInfoRequestModel: Codable {
	public let expenseGroupId: UUID
	public let expenseGroupInfo: ExpenseInfo
	
	public init (
		expenseGroupId: UUID,
		expenseGroupInfo: ExpenseInfo
	) {
		self.expenseGroupInfo = expenseGroupInfo
		self.expenseGroupId = expenseGroupId
	}
}
