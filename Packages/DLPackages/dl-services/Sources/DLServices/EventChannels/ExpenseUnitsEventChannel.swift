import Combine
import Dependencies
import DLModels
import Foundation

public enum ExpenseUnitsEvent {
	case expenseAdded(Expense, superExpenseGroupId: UUID?)
	case expenseUpdated(Expense)
	case expenseDeleted(Expense)
	case expenseDeletionFailure(Error, Expense)

	case expenseGroupAdded(ExpenseGroup, superExpenseGroupId: UUID?)
	case expenseGroupUpdated(ExpenseGroup)
	case expenseGroupDeleted(ExpenseGroup)
	case expenseGroupDeletionFailure(Error, ExpenseGroup)
}

public typealias ExpenseUnitsEventChannel = PassthroughSubject<ExpenseUnitsEvent, Never>

public enum ExpenseUnitsEventChannelDependencyKey: DependencyKey {
	public static var liveValue: ExpenseUnitsEventChannel {
		ExpenseUnitsEventChannel()
	}
}

public extension DependencyValues {
	var expenseUnitsEventChannel: ExpenseUnitsEventChannel {
		get { self[ExpenseUnitsEventChannelDependencyKey.self] }
		set { self[ExpenseUnitsEventChannelDependencyKey.self] = newValue }
	}
}
