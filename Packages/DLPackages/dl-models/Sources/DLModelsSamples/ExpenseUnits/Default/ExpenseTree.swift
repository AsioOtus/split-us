import DLModels
import Multitool

public extension ExpenseTree {
	static let helsinki = Self.init(
		expenseGroup: .helsinki,
		expenseTrees: [
			.init(expense: .beer),
			.init(expense: .train),
			.init(expense: .iceCream),
			.init(expense: .longName),
		]
	)
}
