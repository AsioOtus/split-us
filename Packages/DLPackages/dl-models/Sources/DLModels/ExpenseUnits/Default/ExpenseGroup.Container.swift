extension ExpenseGroup {
	public typealias Container = ExpenseGroupContainer<ExpenseGroup, ExpenseTree>
}

public extension ExpenseGroup.Container {
	var expenseTree: ExpenseTree {
		.init(
			expenseGroup: expenseGroup,
			expenseTrees: expenseTrees
		)
	}
}
