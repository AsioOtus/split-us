import Foundation
import Multitool

public typealias ExpenseTree = Tree<ExpenseUnit.Default>

public extension ExpenseTree {
	init (expense: Expense) {
		self.init(value: .expense(expense))
	}

	init (expenseGroup: ExpenseGroup, expenseTrees: [ExpenseTree]) {
		self.init(value: .expenseGroup(expenseGroup), nodes: expenseTrees)
	}
}

public extension ExpenseTree where Value: Identifiable {
	@discardableResult
	mutating func appendIfGroup (
		expenseTree: ExpenseTree,
		toExpenseGroup expenseGroupId: UUID
	) -> Bool {
		switch value {
		case .expense:
			return false

		case .expenseGroup(let expenseGroup):
			if expenseGroup.id == expenseGroupId {
				nodes.append(expenseTree)
				return true
			} else {
				for nodeIndex in nodes.indices {
					let isSuccess = nodes[nodeIndex].appendIfGroup(expenseTree: expenseTree, toExpenseGroup: expenseGroupId)
					guard !isSuccess else { return true }
				}

				return false
			}
		}
	}
}

public extension Array where Element == ExpenseTree {
	mutating func removeAll (withId id: UUID) {
		for index in indices {
			self[index].removeNodes(withId: id)
		}
	}
}

public extension ExpenseTree {
	var id: UUID {
		switch self.value {
		case .expense(let expense): expense.id
		case .expenseGroup(let expenseGroup): expenseGroup.id
		}
	}

	var info: ExpenseInfo {
		switch self.value {
		case .expense(let expense): expense.info
		case .expenseGroup(let expenseGroup): expenseGroup.info
		}
	}

	var amounts: [Amount?] {
		switch self.value {
		case .expense(let expense): [expense.totalAmount]
		case .expenseGroup: nodes.amounts
		}
	}

	var summarizedAmounts: [Amount] {
		switch self.value {
		case .expense(let expense): [expense.totalAmount].compactMap { $0 }
		case .expenseGroup: nodes.amountsSum
		}
	}

	var creditors: [User.Compact?] {
		switch self.value {
		case .expense(let expense): [expense.creditor]
		case .expenseGroup: nodes.creditors
		}
	}

	var borrowers: [Expense.Borrower] {
		switch self.value {
		case .expense(let expense): expense.borrowers
		case .expenseGroup: nodes.borrowers
		}
	}
}

public extension ExpenseTree {
	var new: New {
		.init(
			value: {
				switch self.value {
				case .expense(let expense): .expense(expense.new)
				case .expenseGroup(let expenseGroup): .expenseGroup(expenseGroup.new)
				}
			}(),
			nodes: nodes.map(\.new)
		)
	}

	var update: Update {
		.init(
			value: {
				switch self.value {
				case .expense(let expense): .expense(expense.update)
				case .expenseGroup(let expenseGroup): .expenseGroup(expenseGroup.update)
				}
			}(),
			nodes: nodes.map(\.update)
		)
	}
}
