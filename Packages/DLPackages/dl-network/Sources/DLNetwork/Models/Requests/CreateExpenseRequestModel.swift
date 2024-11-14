import DLModels
import Foundation

public struct CreateExpenseRequestModel: Codable {
	public let expense: Expense.New
	public let superExpenseGroupId: UUID?
	public let userGroupId: UUID
	
	public init (
		expense: Expense.New,
		superExpenseGroupId: UUID?,
		userGroupId: UUID
	) {
		self.expense = expense
		self.superExpenseGroupId = superExpenseGroupId
		self.userGroupId = userGroupId
	}
}
