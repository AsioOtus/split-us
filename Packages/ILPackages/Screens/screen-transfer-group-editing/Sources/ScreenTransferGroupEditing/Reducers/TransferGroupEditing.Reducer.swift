import Foundation
import ComposableArchitecture
import ScreenTransferEditing
import DLServices
import DLModels
import DLUtils

extension TransferGroupEditing {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = TransferGroupEditing.State
		public typealias Action = TransferGroupEditing.Action

		@Dependency(\.dismiss) var dismiss
		@Dependency(\.transferService) var transferService
		@Dependency(\.userGroupsService) var userGroupsService
		
		public init () { }

		public var body: some ReducerOf<Self> {
			BindingReducer()

			Reduce { state, action in
				switch action {
				case .binding(\.sharedInfo): handleBindingSharedInfo(&state)
				case .binding: break
				case .initialize: return initialize(&state)

				case .refresh: break
				case .onRefreshCompleted: break

				case .toggleSharedInfo: toggleSharedInfo(&state)

				case .onUsersResponse(let users): onUsersResponse(users, &state)

				case .onSubmitButtonTap: break
				case .onCancelButtonTap: return onCancelButtonTap()

				case .onCreationCompleted: break
				case .onUpdatingCompleted: break

				case .onTransferGroupCreateButtonTap: onTransferGroupCreateButtonTap(&state)
				case .onTransferCreateButtonTap: onTransferCreateButtonTap(&state)

				case .transfers: break
				case .transferGroupEditing(.presented(let transferGroupEditingAction)): return transferGroupEditingActions(&state, transferGroupEditingAction)
				case .transferEditing(.presented(let transferEditingAction)): return transferEditingActions(&state, transferEditingAction)
				case .transferGroupEditing(.dismiss): break
				case .transferEditing(.dismiss): break
				}

				return .none
			}
			.ifLet(\.$transferEditing, action: \.transferEditing) { TransferEditing.Reducer() }
			.ifLet(\.$transferGroupEditing, action: \.transferGroupEditing) { TransferGroupEditing.Reducer() }

			Scope(state: \.self, action: \.transfers) {
				TransferGroupEditing.TransfersReducer()
			}

			TransferGroupEditing.CreationReducer()
			TransferGroupEditing.UpdatingReducer()
		}
	}
}

// MARK: - Child reducers
private extension TransferGroupEditing.Reducer {
	func transferGroupEditingActions (
		_ state: inout State,
		_ action: TransferGroupEditing.Reducer.Action
	) -> Effect<Action> {
		switch action {
		case .onCreationCompleted(.successful(let transferGroupContainer)): onTransferGroupCreationCompleted(transferGroupContainer, &state)
		case .onUpdatingCompleted(.successful(let transferGroupContainer)): onTransferGroupUpdatingCompleted(transferGroupContainer, &state)
		default: break
		}
		
		return .none
	}
	
	func transferEditingActions (
		_ state: inout State,
		_ action: TransferEditing.Reducer.Action
	) -> Effect<Action> {
		switch action {
		case .onCreationCompleted(.successful(let transferUnit)): onTransferCreationCompleted(transferUnit, &state)
		case .onUpdatingCompleted(.successful(let transferUnit)): onTransferUpdatingCompleted(transferUnit, &state)
		default: break
		}
		
		return .none
	}
}

// MARK: - Binding handlers
private extension TransferGroupEditing.Reducer {
	func handleBindingSharedInfo (_ state: inout State) {
		updateSharedInfoRemainingAmountValue(&state)
	}
}

// MARK: - Action handlers
private extension TransferGroupEditing.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		if let groupContainer = state.initialTransferGroupContainer {
			state.name = groupContainer.transferGroup.info.name ?? ""
			state.note = groupContainer.transferGroup.info.note ?? ""
			state.date = groupContainer.transferGroup.info.date ?? .init()

			state.transferUnits = .successful(groupContainer.transferUnits)
		}

		updateSharedInfoRemainingAmountValue(&state)

		return loadUsers(&state)
	}

	func toggleSharedInfo (_ state: inout State) {
		state.sharedInfo.isEnabled.toggle()
	}

	func onTransferGroupCreateButtonTap (_ state: inout State) {
		state.transferGroupEditing = .creation(
			isLocal: state.isLocal || state.isCreation,
			superTransferGroupId: state.superTransferGroupId,
			userGroup: state.userGroup,
			sharedInfo: state.sharedInfo.set(amountValue: state.sharedInfo.remainingAmountValue ?? 0)
		)
	}
	
	func onTransferCreateButtonTap (_ state: inout State) {
		let initialCreditor = state.sharedInfo.isEnabled ? state.sharedInfo.creditor : nil
		let remainingAmountValue = state.sharedInfo.isEnabled ? state.sharedInfo.remainingAmountValue : nil

		state.transferEditing = .creation(
			isLocal: state.isLocal || state.isCreation,
			superTransferGroupId: state.superTransferGroupId,
			userGroup: state.userGroup,
			initialCreditor: initialCreditor,
			remainingAmountValue: remainingAmountValue
		)
	}
	
	func onCancelButtonTap () -> Effect<Action> {
		.run { _ in await dismiss() }
	}

	func onUsersResponse (_ users: Loadable<[User.Compact]>, _ state: inout State) {
		state.users = users
	}

	func delete (transferUnitId: UUID, state: inout State) {
		state.transferUnits = state.transferUnits.mapSuccessfulValue {
			var transferUnits = $0
			transferUnits.removeAll(withId: transferUnitId)
			return transferUnits
		}
	}
}

// MARK: - Transfer group editing actions
private extension TransferGroupEditing.Reducer {
	func onTransferGroupCreationCompleted (_ transferGroupContainer: TransferGroup.Container, _ state: inout State) {
		guard
			let transferGroupEditing = state.transferGroupEditing
		else { return }
		
		if transferGroupEditing.isLocal {
			insert(transferGroupContainer.transferUnit, transferGroupEditing.superTransferGroupId, &state)
			updateSharedInfoRemainingAmountValue(&state)
		} else if state.isCreation {
			
		}
	}
	
	func onTransferGroupUpdatingCompleted (_ transferGroupContainer: TransferGroup.Container, _ state: inout State) {
		guard
			let transferGroupEditing = state.transferGroupEditing
		else { return }
		
		if transferGroupEditing.isLocal {
			update(transferGroupContainer.transferUnit, transferGroupEditing.superTransferGroupId, &state)
			updateSharedInfoRemainingAmountValue(&state)
		} else if state.isCreation {
			
		}
	}
}

// MARK: - Transfer editing actions
private extension TransferGroupEditing.Reducer {
	func onTransferCreationCompleted (_ transferUnit: TransferUnit, _ state: inout State) {
		guard
			let transferEditing = state.transferEditing
		else { return }
		
		if transferEditing.isLocal {
			insert(transferUnit, transferEditing.superTransferGroupId, &state)
			updateSharedInfoRemainingAmountValue(&state)
		} else if state.isCreation {
			
		}
	}
	
	func onTransferUpdatingCompleted (_ transferUnit: TransferUnit, _ state: inout State) {
		guard
			let transferEditing = state.transferEditing
		else { return }
		
		if transferEditing.isLocal {
			update(transferUnit, transferEditing.superTransferGroupId, &state)
			updateSharedInfoRemainingAmountValue(&state)
		} else if state.isCreation {
			
		}
	}
}

// MARK: - Functions
private extension TransferGroupEditing.Reducer {
	func insert (
		_ transferUnit: TransferUnit,
		_ superTransferGroupId: UUID?,
		_ state: inout State
	) {
		var transferUnits = state.transferUnits.value ?? []
		
		if let superTransferGroupId {
			for index in transferUnits.indices {
				let isSuccess = transferUnits[index].appendIfGroup(transferUnit: transferUnit, toTransferGroup: superTransferGroupId)
				guard !isSuccess else { break }
			}
			
			state.transferUnits = .successful(transferUnits)
		} else {
			state.transferUnits = .successful([transferUnit] + transferUnits)
		}
	}
	
	func update (
		_ transferUnit: TransferUnit,
		_ superTransferGroupId: UUID?,
		_ state: inout State
	) {
		var transferUnits = state.transferUnits.value ?? []
		
		if let superTransferGroupId {
			for index in transferUnits.indices {
				let isSuccess = transferUnits[index].appendIfGroup(transferUnit: transferUnit, toTransferGroup: superTransferGroupId)
				guard !isSuccess else { break }
			}
		} else {
			for index in transferUnits.indices {
				if transferUnits[index].id == transferUnit.id {
					transferUnits[index] = transferUnit
				}
			}
		}
		
		state.transferUnits = .successful(transferUnits)
	}

	func updateSharedInfoRemainingAmountValue (_ state: inout State) {
		guard let sharedAmountValue = state.sharedInfo.amountValue else {
			state.sharedInfo.remainingAmountValue = 0
			return
		}

		guard let amountValue = state.transferUnits.value?.amountsSum.first(where: { $0.currency == state.sharedInfo.currency })?.value
		else {
			state.sharedInfo.remainingAmountValue = sharedAmountValue
			return
		}

		state.sharedInfo.remainingAmountValue = sharedAmountValue - amountValue
	}

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
