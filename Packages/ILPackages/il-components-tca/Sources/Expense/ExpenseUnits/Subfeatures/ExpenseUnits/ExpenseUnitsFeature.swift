import ComposableArchitecture
import DLModels
import DLServices
import Foundation
import ILUtilsTCA

public enum ExpenseUnitsFeature {
	@ObservableState
	public struct State: Hashable {
		public let userGroupId: UUID
		public let superExpenseGroupId: UUID?
		public let isRoot: Bool

		public var isLoading = false
		public var expenseUnits: IdentifiedArrayOf<ExpenseUnitFeature.State> = []
		public var currentPage = -1
		public var pageSize = 30

		var source: ExpenseUnitSource {
			if let superExpenseGroupId {
				.superExpenseGroup(superExpenseGroupId)
			} else {
				.userGroup(userGroupId)
			}
		}

		public init (
			isRoot: Bool,
			superExpenseGroupId: UUID?,
			userGroupId: UUID
		) {
			self.isRoot = isRoot
			self.superExpenseGroupId = superExpenseGroupId
			self.userGroupId = userGroupId
		}
	}

	@CasePathable
	public enum Action {
		case initialize
		case refresh

		case onFirstPage
		case onNextPage
		case onExpenseUnitsLoadingSuccess([ExpenseUnit.Default], Page)
		case onExpenseUnitsLoadingFailure(Error, Page)

		case expenseUnitEvent(ExpenseUnitsEvent)

		indirect case expenseUnits(IdentifiedActionOf<ExpenseUnitFeature.Reducer>)
	}
}

public extension ExpenseUnitsFeature.Action {
	var root: Root? {
		if case .expenseUnits(.element(id: _, action: let action)) = self {
			action.root
		} else {
			nil
		}
	}

	enum Root {
		case addExpense(superExpenseGroup: ExpenseGroup?)
		case updateExpense(Expense)
		case deleteExpense(Expense)

		case addExpenseGroup(superExpenseGroup: ExpenseGroup?)
		case updateExpenseGroup(ExpenseGroup)
		case deleteExpenseGroup(ExpenseGroup)
	}
}
