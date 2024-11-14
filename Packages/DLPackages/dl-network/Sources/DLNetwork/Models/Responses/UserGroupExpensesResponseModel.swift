import DLModels

public struct UserGroupExpensesResponseModel: Codable {
	public let expenseTrees: [ExpenseTree]

	public init (expenseTrees: [ExpenseTree]) {
		self.expenseTrees = expenseTrees
	}
}
