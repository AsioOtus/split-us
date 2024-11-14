import DLModels

public struct UpdateExpenseRequestModel: Codable {
	public let expense: Expense.Update
	
	public init (
		expense: Expense.Update
	) {
		self.expense = expense
	}
}
