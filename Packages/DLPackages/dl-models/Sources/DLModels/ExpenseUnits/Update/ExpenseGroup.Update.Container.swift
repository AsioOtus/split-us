extension ExpenseGroup.Update {
	public typealias Container = ExpenseGroupContainer<ExpenseGroup.Update, ExpenseTree.Update>
}

public extension ExpenseGroup.Update.Container {
	var expenseTree: ExpenseTree.Update {
		.init(
			expenseGroup: expenseGroup,
			expenseTrees: expenseTrees
		)
	}
}
