import ComposableArchitecture
import DLModels
import Foundation
import ILUtilsTCA

public enum ExpenseGroupFeature {
	@ObservableState
	public struct State: Hashable {
		public let userGroupId: UUID
		public let superExpenseGroupId: UUID?
		public let page: Page
		public let expenseGroup: ExpenseGroup
		public var expenseUnits: ExpenseUnitsFeature.State
		public var isExpanded = false

		init (
			expenseGroup: ExpenseGroup,
			page: Page,
			superExpenseGroupId: UUID?,
			userGroupId: UUID
		) {
			self.expenseGroup = expenseGroup
			self.page = page
			self.superExpenseGroupId = superExpenseGroupId
			self.userGroupId = userGroupId
			
			self.expenseUnits = .init(
				isRoot: false,
				superExpenseGroupId: expenseGroup.id,
				userGroupId: userGroupId
			)
		}
	}

	@CasePathable
	public enum Action: BindableAction {
		case binding(BindingAction<State>)

		case onAddExpenseButtonTap(superExpenseGroup: ExpenseGroup)
		case onAddExpenseGroupButtonTap(superExpenseGroup: ExpenseGroup)
		case onUpdateButtonTap(ExpenseGroup)
		case onDeleteButtonTap(ExpenseGroup)

		case expenseUnits(ExpenseUnitsFeature.Action)
	}
}

public extension ExpenseGroupFeature.Action {
	var root: ExpenseUnitsFeature.Action.Root? {
		switch self {
		case .onAddExpenseButtonTap(let superExpenseGroup): .addExpense(superExpenseGroup: superExpenseGroup)
		case .onAddExpenseGroupButtonTap(let superExpenseGroup): .addExpenseGroup(superExpenseGroup: superExpenseGroup)
		case .onUpdateButtonTap(let expenseGroup): .updateExpenseGroup(expenseGroup)
		case .onDeleteButtonTap(let expenseGroup): .deleteExpenseGroup(expenseGroup)
		case .expenseUnits(let action): action.root
		default: nil
		}
	}
}
