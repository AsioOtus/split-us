import AmountComponents
import ComposableArchitecture
import Foundation
import DLServices
import DLModels
import DLUtils

public enum TransferEditing {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = TransferEditing.State
		public typealias Action = TransferEditing.Action

		@Dependency(\.dismiss) var dismiss

		@Dependency(\.transferService) var transferService
		@Dependency(\.userGroupsService) var userGroupsService

		public init () { }

		public var body: some ComposableArchitecture.Reducer<State, Action> {
			BindingReducer()

			Reduce { state, action in
				switch action {
				case .binding(\.perItemAmountValueInput): bindingPerItemAmountValue(&state)
				case .binding(\.itemCount): bindingItemCount(&state)
				case .binding: break

				case .initialize: return initialize(&state)
				case .refresh: break

				case .onSubmitButtonTap: break
				case .onCancelButtonTap: return onCancelButtonTap()

				case .onCreationCompleted: break
				case .onUpdatingCompleted: break

				case .onUsersResponse(let users): onUsersResponse(users, &state)

				case .creditorSelectedMenu: break
				}

				return .none
			}

			TransferEditing.CreationReducer()
			TransferEditing.UpdatingReducer()
		}
	}
}

private extension TransferEditing.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		setInitialValues(state.initialTransferUnit, &state)
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

	func onCancelButtonTap () -> Effect<Action> {
		.run { _ in await dismiss() }
	}

	func bindingPerItemAmountValue (_ state: inout State) {
		state.amountValueSplitInteractor?.onTotalAmountValueChanged(state.totalAmountValue)

		if let initialRemainingAmountValue = state.initialRemainingAmountValue {
			state.remainingAmountValue = initialRemainingAmountValue - state.totalAmountValue
		}
	}

	func bindingItemCount (_ state: inout State) {
		state.amountValueSplitInteractor?.onTotalAmountValueChanged(state.totalAmountValue)

		if let initialRemainingAmountValue = state.initialRemainingAmountValue {
			state.remainingAmountValue = initialRemainingAmountValue - state.totalAmountValue
		}
	}
}

private extension TransferEditing.Reducer {
	func setInitialValues (_ initialTransferUnit: TransferUnit?, _ state: inout State) {
		guard let initialTransferUnit = state.initialTransferUnit
		else { return }

		state.name = initialTransferUnit.info.name
		state.note = initialTransferUnit.info.note
		state.date = initialTransferUnit.info.date

		switch initialTransferUnit.value {
		case .transfer(let transfer):
			setInitialValuesTransfer(transfer, &state)
		case .transferGroup:
			break
		case .transferSplitGroup(let transferSplitGroup):
			setInitialValuesTransferSplitGroup(transferSplitGroup, &state)
		}
	}

	func setInitialValuesTransfer (_ initialTransfer: Transfer, _ state: inout State) {
		state.creditor = initialTransfer.creditor
		state.perItemAmountValueInput = initialTransfer.amount.value
		state.currency = initialTransfer.amount.currency
	}

	func setInitialValuesTransferSplitGroup (_ initialTransferSplitGroup: TransferSplitGroup, _ state: inout State) {
		state.creditor = initialTransferSplitGroup.creditor
		state.perItemAmountValueInput = initialTransferSplitGroup.amount.value
		state.currency = initialTransferSplitGroup.amount.currency
	}

	func createAmountValueSplitInteractor (
		_ users: [User.Compact],
		_ state: State
	) -> AmountValueSplitInteractor {
		if state.isCreation {
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
			totalAmountValue: state.totalAmountValue
		)
	}

	func createUpdatingAmountValueSplitInteractor (
		_ users: [User.Compact],
		_ state: State
	) -> AmountValueSplitInteractor {
		let borrowerAmounts: [UUID: Int] = switch state.initialTransferUnit?.value {
		case .transfer(let transfer):
			transfer.borrower.map { [$0.id: transfer.amount.value ?? 0] } ?? [:]
		case .transferGroup:
			[:]
		case .transferSplitGroup(let transferSplitGroup):
			.init(uniqueKeysWithValues: transferSplitGroup.borrowerAmounts.map { ($0.id, $1 ?? 0) })
		case .none:
			[:]
		}

		let users: [SplitUser] = users
			.map { user in
				if let borrowerAmountValue = borrowerAmounts.first(where: { key, _ in key == user.id }) {
					.init(
						user: user,
						selectionState: .locked,
						splitValue: 0,
						amountValue: borrowerAmountValue.value,
						sliderValue: 0
					)
				} else {
					.init(user: user)
				}
			}

		return .init(
			users: users,
			totalAmountValue: state.totalAmountValue
		)
	}
}

private extension TransferEditing.Reducer {
	func loadUsers (_ state: inout State) -> Effect<Action> {
		state.users.setLoading()

		return .run { [state] send in
			let users = await Loadable {
				try await userGroupsService.users(userGroupId: state.userGroup.id)
			}

			await send(.onUsersResponse(users))
		}
	}
}
