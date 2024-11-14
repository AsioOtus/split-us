import Multitool

public extension ExpenseTree {
	typealias Update = Tree<ExpenseUnit.Update>
}

public extension ExpenseTree.Update {
	init (expense: Expense.Update) {
		self.init(value: .expense(expense))
	}

	init (expenseGroup: ExpenseGroup.Update, expenseTrees: [ExpenseTree.Update]) {
		self.init(value: .expenseGroup(expenseGroup), nodes: expenseTrees)
	}
}
