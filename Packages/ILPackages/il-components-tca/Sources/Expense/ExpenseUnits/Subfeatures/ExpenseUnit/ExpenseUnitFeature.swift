import ComposableArchitecture
import DLModels
import DLServices
import Foundation

public enum ExpenseUnitFeature {
	@CasePathable
	@ObservableState
	public enum State: Identifiable, Hashable {
		case expense(ExpenseFeature.State)
		case expenseGroup(ExpenseGroupFeature.State)

		public var id: UUID {
			switch self {
			case .expense(let state): state.expense.id
			case .expenseGroup(let state): state.expenseGroup.id
			}
		}

		public var page: Page {
			switch self {
			case .expense(let state): state.page
			case .expenseGroup(let state): state.page
			}
		}

		public var date: Date? {
			switch self {
			case .expense(let state): state.expense.info.date
			case .expenseGroup(let state): state.expenseGroup.info.date
			}
		}
	}

	@CasePathable
	public enum Action {
		case expense(ExpenseFeature.Action)
		case expenseGroup(ExpenseGroupFeature.Action)
	}
}

public extension ExpenseUnitFeature.Action {
	var root: ExpenseUnitsFeature.Action.Root? {
		switch self {
		case .expense(let action): nil
		case .expenseGroup(let action): action.root
		}
	}
}
