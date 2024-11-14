import ComponentsTCAExpense
import ComposableArchitecture
import DLModels
import DLServices
import Foundation
import ScreenSummary
import ScreenUserGroupInfo
import ScreenExpenseEditing
import ScreenExpenseGroupEditing

extension UserGroupDetails {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = UserGroupDetails.State
		public typealias Action = UserGroupDetails.Action

		@Dependency(\.expenseService) var expenseService
		@Dependency(\.expenseUnitsEventChannel) var expenseUnitsEventChannel

		public init () { }

		public var body: some ReducerOf<Self> {
			Reduce { state, action in
				switch action {
				case .initialize: return initialize(&state)

				case .onTitleTap: onInfoButtonTap(&state)
				case .onSummaryButtonTap: onSummaryButtonTap(&state)
				case .onInfoButtonTap: onInfoButtonTap(&state)
					
				case .onAddExpenseButtonTap: addExpense(nil, &state)
				case .onAddExpenseGroupButtonTap: addExpenseGroup(nil, &state)

				case .expenseUnits(let action):
					switch action.root {
					case .addExpense(superExpenseGroup: let superExpenseGroup): addExpense(superExpenseGroup, &state)
					case .updateExpense(let expense): updateExpense(expense, &state)
					case .addExpenseGroup(superExpenseGroup: let superExpenseGroup): addExpenseGroup(superExpenseGroup, &state)
					case .updateExpenseGroup(let expenseGroup): updateExpenseGroup(expenseGroup, &state)
					default: break
					}

				default: break
				}

				return .none
			}
			.ifLet(\.$summary, action: \.summary) {
				Summary.Reducer()
			}
			.ifLet(\.$userGroupInfo, action: \.userGroupInfo) {
				UserGroupInfo.Reducer()
			}
			.ifLet(\.$expenseEditing, action: \.expenseEditing) {
				ExpenseEditing.Reducer()
			}
			.ifLet(\.$expenseGroupEditing, action: \.expenseGroupEditing) {
				ExpenseGroupEditing.Reducer()
			}

			Scope(state: \.expenseUnits, action: \.expenseUnits) {
				ExpenseUnitsFeature.Reducer()
				ExpenseUnitsFeature.DeletionReducer()
			}
		}
	}
}

private extension UserGroupDetails.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		subscribeOnExpenseUnitsEventChannel()
	}

	func onInfoButtonTap (_ state: inout State) {
		state.userGroupInfo = .init(userGroup: state.userGroup)
	}

	func onSummaryButtonTap (_ state: inout State) {
		state.summary = .init(userGroup: state.userGroup)
	}
}

private extension UserGroupDetails.Reducer {
	func subscribeOnExpenseUnitsEventChannel () -> Effect<Action>  {
		.publisher { expenseUnitsEventChannel.map(Action.expenseUnitEvent) }
	}
}

private extension UserGroupDetails.Reducer {
	func addExpense (
		_ superExpenseGroup: ExpenseGroup?,
		_ state: inout State
	) {
		state.expenseEditing = .creation(
			superExpenseGroupId: superExpenseGroup?.id,
			userGroup: state.userGroup
		)
	}

	func updateExpense (
		_ expense: Expense,
		_ state: inout State
	) {
		state.expenseEditing = .updating(
			id: state.id,
			userGroup: state.userGroup
		)
	}

	func updateExpenseGroup (
		_ expenseGroup: ExpenseGroup,
		_ state: inout State
	) {
		state.expenseGroupEditing = .updating(
			expenseGroupId: expenseGroup.id,
			userGroup: state.userGroup
		)
	}

	func addExpenseGroup (
		_ superExpenseGroup: ExpenseGroup?,
		_ state: inout State
	) {
		state.expenseGroupEditing = .creation(
			superExpenseGroupId: superExpenseGroup?.id,
			userGroup: state.userGroup
		)
	}
}
