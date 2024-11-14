import ComponentsTCAExpense
import ComposableArchitecture
import DLModels
import DLServices
import Foundation
import ILComponents
import Multitool

public enum ExpenseEditing {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = ExpenseEditing.State
		public typealias Action = ExpenseEditing.Action

		@Dependency(\.dismiss) var dismiss

		@Dependency(\.expenseService) var expenseService
		@Dependency(\.expenseLocalService) var expenseLocalService
		@Dependency(\.userGroupsService) var userGroupsService
		@Dependency(\.usersService) var usersService

		public init () { }

		public var body: some ComposableArchitecture.Reducer<State, Action> {
			BindingReducer()

			Reduce { state, action in
				switch action {
				case .binding(\.amountValuePerItem): bindingAmountValuePerItem(&state)
				case .binding(\.itemCount): bindingItemCount(&state)

				case .initialize: return initialize(&state)

				case .onSubmitButtonTap: return onSubmitButtonTap(&state)
				case .onCancelButtonTap: return onCancelButtonTap()

				case .onUsersResponse(let users): onUsersResponse(users, &state)

				default: break
				}

				return .none
			}

			Scope(state: \.expenseInfoEditing, action: \.expenseInfoEditing) {
				ExpenseInfoEditing.Reducer()
			}
		}
	}
}

private extension ExpenseEditing.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		return loadUsers(&state)
	}

	func refresh (_ state: inout State) -> Effect<Action> {
		loadUsers(&state)
	}

	func onUsersResponse (_ users: Loadable<[User.Compact]>, _ state: inout State) {
		state.users = users

		if let users = users.value {
			state.amountValueSplitInteractor = createAmountValueSplitInteractor(users, state)
		}
	}

	func onSubmitButtonTap (_ state: inout State) -> Effect<Action> {
		saveLocal(&state)
	}

	func onCancelButtonTap () -> Effect<Action> {
		.run { _ in await dismiss() }
	}

	func bindingAmountValuePerItem (_ state: inout State) {
		state.amountValueSplitInteractor?.onTotalAmountValueChanged(state.totalAmountValue)
	}

	func bindingItemCount (_ state: inout State) {
		state.amountValueSplitInteractor?.onTotalAmountValueChanged(state.totalAmountValue)
	}
}

private extension ExpenseEditing.Reducer {
	func createAmountValueSplitInteractor (
		_ users: [User.Compact],
		_ state: State
		
	) -> AmountValueSplitInteractor {
		if state.mode.isCreation {
			return createCreationAmountValueSplitInteractor(users, state)
		} else {
			return createUpdatingAmountValueSplitInteractor(users, state)
		}
	}

	func createCreationAmountValueSplitInteractor (
		_ users: [User.Compact],
		_ state: State
	) -> AmountValueSplitInteractor {
		.init(
			users: users.map(SplitUser.init),
			totalAmountValue: state.totalAmountValue,
			currency: state.currency
		)
	}

	func createUpdatingAmountValueSplitInteractor (
		_ users: [User.Compact],
		_ state: State
	) -> AmountValueSplitInteractor {
//		let borrowers = state
//			.users
//			.map { ($0.id, $0.amountValue ?? 0) } ?? []
//
//		let borrowerAmounts: [UUID: Int] = Dictionary(borrowers, uniquingKeysWith: { first, _ in first })
//
//		let users: [SplitUser] = users
//			.map { user in
//				if let borrowerAmountValue = borrowerAmounts.first(where: { key, _ in key == user.id }) {
//					.init(
//						user: user,
//						selectionState: .locked,
//						splitValue: 0,
//						amountValue: borrowerAmountValue.value,
//						sliderValue: 0
//					)
//				} else {
//					.init(user: user)
//				}
//			}

		return .init(
			users: [],
			totalAmountValue: state.totalAmountValue,
			currency: state.currency
		)
	}
}

private extension ExpenseEditing.Reducer {
	func loadUsers (_ state: inout State) -> Effect<Action> {
		state.users.setLoading()

		return .run { [state] send in
			let users = await Loadable {
				try await usersService.userGroupMembers(
					userGroupId: state.userGroup.id,
					page: .init(number: 0, size: 100)
				)
				.map(\.user)
			}

			await send(.onUsersResponse(users))
		}
	}

	func saveLocal (_ state: inout State) -> Effect<Action> {
		.run { [state] send in
			try expenseLocalService.createExpense(
				state.newExpense,
				superExpenseGroupId: state.superExpenseGroupId,
				userGroupId: state.userGroup.id
			)

//			await send(.saveLocalSuccess)
		} catch: { error, send in
//			await send(.saveLocalFailure(error))
		}
	}
}
