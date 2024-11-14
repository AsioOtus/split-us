import Multitool

public extension ExpenseTree {
	typealias New = Tree<ExpenseUnit.New>
}

public extension ExpenseTree.New {
	init (expense: Expense.New) {
		self.init(value: .expense(expense))
	}

	init (expenseGroup: ExpenseGroup.New, expenseTrees: [ExpenseTree.New]) {
		self.init(value: .expenseGroup(expenseGroup), nodes: expenseTrees)
	}
}
