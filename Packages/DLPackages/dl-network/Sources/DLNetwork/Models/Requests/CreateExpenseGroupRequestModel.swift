import DLModels
import Foundation

public struct CreateExpenseGroupRequestModel: Codable {
	public let expenseGroupContainer: ExpenseGroup.New.Container
	public let superExpenseGroupId: UUID?
	public let userGroupId: UUID
	
	public init (
		expenseGroupContainer: ExpenseGroup.New.Container,
		superExpenseGroupId: UUID?,
		userGroupId: UUID
	) {
		self.expenseGroupContainer = expenseGroupContainer
		self.superExpenseGroupId = superExpenseGroupId
		self.userGroupId = userGroupId
	}
}
