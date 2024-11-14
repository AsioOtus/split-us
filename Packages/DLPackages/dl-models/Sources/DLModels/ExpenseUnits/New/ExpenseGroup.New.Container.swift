extension ExpenseGroup.New {
	public typealias Container = ExpenseGroupContainer<ExpenseGroup.New, ExpenseTree.New>
}

public extension ExpenseGroup.New.Container {
	var expenseTree: ExpenseTree.New {
		.init(
			expenseGroup: expenseGroup,
			expenseTrees: expenseTrees
		)
	}
}
