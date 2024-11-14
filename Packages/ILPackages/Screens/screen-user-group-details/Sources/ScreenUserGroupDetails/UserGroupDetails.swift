import ComponentsTCAExpense
import ComposableArchitecture
import DLModels
import DLServices
import Foundation
import ScreenSummary
import ScreenUserGroupInfo
import ScreenExpenseEditing
import ScreenExpenseGroupEditing

public enum UserGroupDetails { }

extension UserGroupDetails {
	@ObservableState
	public struct State: Equatable, Identifiable {
		let userGroup: UserGroup

		var expenseUnits: ExpenseUnitsFeature.State

		@Presents var expenseEditing: ExpenseEditing.State?
		@Presents var expenseGroupEditing: ExpenseGroupEditing.State?
		@Presents var summary: Summary.State?
		@Presents var userGroupInfo: UserGroupInfo.State?

		public var id: UUID { userGroup.id }

		public init (userGroup: UserGroup) {
			self.userGroup = userGroup
			self.expenseUnits = .init(
				isRoot: true,
				superExpenseGroupId: nil,
				userGroupId: userGroup.id
			)
		}
	}
}

extension UserGroupDetails {
	@CasePathable
	public enum Action {
		case initialize

		case onTitleTap
		case onSummaryButtonTap
		case onInfoButtonTap

		case onAddExpenseButtonTap
		case onAddExpenseGroupButtonTap

		case expenseUnitEvent(ExpenseUnitsEvent)

		case expenseUnits(ExpenseUnitsFeature.Action)
		case expenseEditing(PresentationAction<ExpenseEditing.Action>)
		case expenseGroupEditing(PresentationAction<ExpenseGroupEditing.Action>)
		case summary(PresentationAction<Summary.Action>)
		case userGroupInfo(PresentationAction<UserGroupInfo.Action>)
	}
}
