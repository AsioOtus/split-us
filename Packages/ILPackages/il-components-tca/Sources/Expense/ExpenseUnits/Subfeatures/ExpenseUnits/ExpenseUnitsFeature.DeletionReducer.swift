import ComposableArchitecture
import DLModels
import DLServices
import Foundation

extension ExpenseUnitsFeature {
	@Reducer
	public struct DeletionReducer {
		public typealias State = ExpenseUnitsFeature.State
		public typealias Action = ExpenseUnitsFeature.Action

		@Dependency(\.expenseService) var expenseService
		@Dependency(\.expenseLocalService) var expenseLocalService
		@Dependency(\.expenseUnitsEventChannel) var expenseUnitsEventChannel

		public init () { }

		public var body: some ReducerOf<ExpenseUnitsFeature.Reducer> {
			Reduce { state, action in
				switch action {
				case .initialize: return initialize(&state)

				default: break
				}

				if case .deleteExpenseGroup(let expenseGroup) = action.root {
					return deleteExpenseGroup(expenseGroup, &state)
				}

				return .none
			}
		}
	}
}

private extension ExpenseUnitsFeature.DeletionReducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		subscribeOnExpenseUnitsEventChannel()
	}
}

private extension ExpenseUnitsFeature.DeletionReducer {
	func subscribeOnExpenseUnitsEventChannel () -> Effect<Action>  {
		.publisher { expenseUnitsEventChannel.map(Action.expenseUnitEvent) }
		.animation()
	}

	func deleteExpenseGroup (
		_ expenseGroup: ExpenseGroup,
		_ state: inout State
	) -> Effect<Action> {
		.run { _ in
			if expenseGroup.offlineStatus.isOfflineCreated {
				try expenseLocalService.delete(id: expenseGroup.id)
			} else {
				try await expenseService.deleteExpenseGroup(id: expenseGroup.id)
				try expenseLocalService.delete(id: expenseGroup.id)
			}

			expenseUnitsEventChannel.send(.expenseGroupDeleted(expenseGroup))
		} catch: { error, _ in
			expenseUnitsEventChannel.send(.expenseGroupDeletionFailure(error, expenseGroup))
		}
	}
}
