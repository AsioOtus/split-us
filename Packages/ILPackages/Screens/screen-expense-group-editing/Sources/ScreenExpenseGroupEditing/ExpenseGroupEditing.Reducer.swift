import ComposableArchitecture
import ComponentsTCAExpense
import ComponentsTCAGeneral
import ComponentsTCAUser
import DLModels
import DLServices
import Foundation
import Multitool
import ScreenExpenseEditing

extension ExpenseGroupEditing {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = ExpenseGroupEditing.State
		public typealias Action = ExpenseGroupEditing.Action

		@Dependency(\.expenseService) var expenseService
		@Dependency(\.expenseLocalService) var expenseLocalService
		@Dependency(\.currentUserService) var currentUserService
		@Dependency(\.networkConnectivityService) var networkConnectivityService

		@Dependency(\.expenseUnitsEventChannel) var expenseUnitsEventChannel

		@Dependency(\.dismiss) var dismiss

		public init () { }

		public var body: some ReducerOf<Self> {
			BindingReducer()

			Reduce { state, action in
				switch action {
				case .binding: break

				case .initialize: return onInitialize(&state)
				case .onActionButtonTap: return onActionButtonTap(&state)
				case .onCancelButtonTap: return onCancelButtonTap(&state)

				case .saveLocalSuccess: saveLocalSuccess(&state)
				case .saveLocalFailure(let error): saveLocalFailure(error, &state)

				case .onExpenseGroupLoadingSuccess(let expenseGroup): onExpenseGroupLoadingSuccess(expenseGroup, &state)
				case .onExpenseGroupLoadingFailure(let error): onExpenseGroupLoadingFailure(error, &state)
				case .onCreationSuccess(let expenseGroup): return onCreationSuccess(expenseGroup, &state)
				case .onCreationFailure(let error): return onCreationFailure(error, &state)
				case .onUpdatingSuccess(let expenseGroup): onUpdatingSuccess(expenseGroup, &state)
				case .onUpdatingFailure(let error): onUpdatingFailure(error, &state)

				case .onAddExpenseButtonTap: addExpense(state.expenseGroup!, &state) // TODO: Remove force unwrapping
				case .onAddExpenseGroupButtonTap: addExpenseGroup(state.expenseGroup!, &state) // TODO: Remove force unwrapping

				case .expenseUnitsFeature(let action):
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
			.ifLet(\.$expenseEditing, action: \.expenseEditing) {
				ExpenseEditing.Reducer()
			}
			.ifLet(\.$expenseGroupEditing, action: \.expenseGroupEditing) {
				ExpenseGroupEditing.Reducer()
			}

			Scope(state: \.connectionStateFeature, action: \.connectionStateFeature) {
				ConnectionStateFeature.Reducer()
			}

			Scope(state: \.userSelector, action: \.userSelector) {
				UserSingleSelector.Reducer()
			}

			Scope(state: \.expenseInfoEditing, action: \.expenseInfoEditing) {
				ExpenseInfoEditing.Reducer()
			}

			Scope(state: \.expenseUnitsFeature, action: \.expenseUnitsFeature) {
				ExpenseUnitsFeature.Reducer()
				ExpenseUnitsFeature.DeletionReducer()
			}
		}
	}
}

// MARK: - Action handlers
private extension ExpenseGroupEditing.Reducer {
	func onInitialize (_ state: inout State) -> Effect<Action> {
		let initTask = {
			switch state.mode {
			case .review:
				return loadExpenseGroup(&state)

			case .creation: break

			case .updating where state.connectionStateFeature.connectionState.isOffline:
				loadExpenseGroupLocal(&state)

				if state.expenseGroup?.offlineStatus.isOfflineCreated == false {
					state.editingError = .offlineUpdateAttempt
					state.mode = .review
					return loadExpenseGroup(&state)
				}

			case .updating:
				return loadExpenseGroup(&state)
			}

			return .none
		}()

		return .merge(
			initTask,
			subscribeOnExpenseUnitsEventChannel()
		)
	}

	func onActionButtonTap (_ state: inout State) -> Effect<Action> {
		switch state.mode {
		case .review:
			state.mode = .updating

		case .creation where
			state.connectionStateFeature.connectionState.isOffline:
			return saveLocal(&state)

		case .creation:
			return create(&state)

		case .updating
			where
			state.connectionStateFeature.connectionState.isOffline &&
			state.expenseGroup?.offlineStatus.isOfflineCreated == false:
			state.editingError = .offlineUpdateAttempt
			state.mode = .review

		case .updating where
			state.connectionStateFeature.connectionState.isOffline &&
			state.expenseGroup?.offlineStatus.isOfflineCreated == true:
			return updateLocal(&state)

		case .updating:
			return update(&state)
		}

		return .none
	}

	func onCancelButtonTap (_ state: inout State) -> Effect<Action> {
		switch state.mode {
		case .review, .creation:
			return .run { _ in await dismiss() }

		case .updating:
			state.mode = .review
			restoreInitial(&state)
			return .none
		}
	}

	func onExpenseGroupLoadingSuccess (_ expenseGroup: ExpenseGroup, _ state: inout State) {
		state.expenseGroupRequest.setSuccessful(expenseGroup)
		state.expenseGroup = expenseGroup

		restoreInitial(&state)
	}

	func onExpenseGroupLoadingFailure (_ error: Error, _ state: inout State) {
		state.expenseGroupRequest.setFailed(error)
		loadExpenseGroupLocal(&state)
	}

	func onCreationSuccess (_ expenseGroup: ExpenseGroup, _ state: inout State) -> Effect<Action> {
		state.submitRequest.setSuccessful(.init())
		state.expenseGroupRequest.setSuccessful(expenseGroup)
		state.id = expenseGroup.id
		state.mode = .review
		state.expenseGroup = expenseGroup

		return .none
	}

	func onCreationFailure (_ error: Error, _ state: inout State) -> Effect<Action> {
		state.submitRequest.setFailed(error)

		if networkConnectivityService.state(error: error).isOffline {
			return saveLocal(&state)
		} else {
			state.editingError = .creationError
			return .none
		}
	}

	func onUpdatingSuccess (_ expenseGroup: ExpenseGroup, _ state: inout State) {
		state.submitRequest.setSuccessful(.init())
		state.id = expenseGroup.id
		state.mode = .review
		state.expenseGroup = expenseGroup
	}

	func onUpdatingFailure (_ error: Error, _ state: inout State) {
		state.submitRequest.setFailed(error)
		state.editingError = .creationError
	}

	func saveLocalSuccess (_ state: inout State) {
		guard let currentUser = currentUserService.user.value?.compact else { return }

		let expenseGroup = ExpenseGroup(
			id: state.id,
			info: state.expenseInfoEditing.resultExpenseInfo,
			offlineStatus: .offlineCreated,
			creator: currentUser
		)

		state.expenseGroup = expenseGroup
		state.mode = .review
		state.isLocalCreationInfoToastVisible = true
		expenseUnitsEventChannel.send(.expenseGroupAdded(expenseGroup, superExpenseGroupId: state.superExpenseGroupId))
	}

	func saveLocalFailure (_ error: Error, _ state: inout State) {
		state.editingError = .creationError
	}
}

private extension ExpenseGroupEditing.Reducer {
	func loadExpenseGroup (_ state: inout State) -> Effect<Action> {
		state.expenseGroupRequest.setLoading(task: nil, value: nil)

		return .run { [state] send in
			let expenseGroup = try await expenseService.expenseGroup(id: state.id)
			await send(.onExpenseGroupLoadingSuccess(expenseGroup))
		} catch: { error, send in
			await send(.onExpenseGroupLoadingFailure(error))
		}
	}

	func loadExpenseGroupLocal (_ state: inout State) {
		guard let localExpenseGroup = try? expenseLocalService.expenseGroup(id: state.id) else { return }
		state.expenseGroup = localExpenseGroup
		restoreInitial(&state)
	}

	func restoreInitial (_ state: inout State) {
		guard let expenseGroup = state.expenseGroup else { return }
		
		state.expenseInfoEditing.set(
			expenseInfo: expenseGroup.info,
			isExpenseGroup: true
		)
	}

	func saveLocal (_ state: inout State) -> Effect<Action> {
		.run { [state] send in
			try expenseLocalService.createExpenseGroup(
				state.newExpenseGroup,
				superExpenseGroupId: state.superExpenseGroupId,
				userGroupId: state.userGroup.id
			)

			await send(.saveLocalSuccess)
		} catch: { error, send in
			await send(.saveLocalFailure(error))
		}
	}

	func updateLocal (_ state: inout State) -> Effect<Action> {
		.run { [state] send in
			guard let currentUserId = currentUserService.user.value?.id else { throw State.EditingError.currentUserIsNil }

			try expenseLocalService.saveExpenseGroup(
				state.newExpenseGroup,
				superExpenseGroupId: state.superExpenseGroupId,
				userGroupId: state.userGroup.id,
				creatorId: currentUserId
			)

			await send(.saveLocalSuccess)
		} catch: { error, send in
			await send(.saveLocalFailure(error))
		}
	}

	func create (_ state: inout State) -> Effect<Action> {
		state.submitRequest.setLoading()

		return .run { [state] send in
			let expenseGroup = try await expenseService.createExpenseGroup(
				expenseGroup: .init(
					id: state.id,
					info: state.expenseInfoEditing.resultExpenseInfo
				),
				superExpenseGroupId: state.superExpenseGroupId,
				userGroupId: state.userGroup.id
			)

			await send(.onCreationSuccess(expenseGroup))
		} catch: { error, send in
			await send(.onCreationFailure(error))
		}
	}

	func update (_ state: inout State) -> Effect<Action> {
		state.submitRequest.setLoading()

		return .run { [state] send in
			let expenseGroup = try await expenseService.updateExpenseGroup(
				expenseGroup: state.updateExpenseGroup
			)

			await send(.onUpdatingSuccess(expenseGroup))
		} catch: { error, send in
			await send(.onUpdatingFailure(error))
		}
	}

	func subscribeOnExpenseUnitsEventChannel () -> Effect<Action>  {
		.publisher { expenseUnitsEventChannel.map(Action.expenseUnitEvent) }
	}
}

private extension ExpenseGroupEditing.Reducer {
	func addExpense (
		_ superExpenseGroup: ExpenseGroup?,
		_ state: inout State
	) {
		state.expenseEditing = .creation(
			superExpenseGroupId: state.superExpenseGroupId,
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
