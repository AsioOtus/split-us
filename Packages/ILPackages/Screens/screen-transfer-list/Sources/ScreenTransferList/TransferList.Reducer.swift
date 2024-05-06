import ComposableArchitecture
import Foundation
import ScreenTransferEditing
import ScreenTransferGroupEditing
import DLServices
import DLModels
import TransferComponents
import DLUtils

public enum TransferList {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = TransferList.State
		public typealias Action = TransferList.Action

		@Dependency(\.userGroupsService) var userGroupService
		@Dependency(\.transferService) var transferService
		
		public init () { }
		
		public var body: some ReducerOf<Self> {
			Reduce { state, action in
				switch action {
				case .initialize: return initialize(&state)
				case .refresh: return refresh(&state)

				case .onTransfersLoaded(let transfers): onTransfersLoaded(transfers, &state)

				case .onTransferCreateButtonTap: onTransferCreateButtonTap(&state)
				case .onTransferGroupCreateButtonTap: onTransferGroupCreateButtonTap(&state)

				case .transfers(let transfersAction): return transfersActions(transfersAction, &state)

				case .transferEditing(let transferEditingAction): return transferEditingActions(transferEditingAction, &state)
				case .transferGroupEditing(let transferGroupEditingAction): return transferGroupEditingActions(transferGroupEditingAction, &state)
				}
				
				return .none
			}
			.ifLet(\.$transferEditing, action: \.transferEditing) { TransferEditing.Reducer() }
			.ifLet(\.$transferGroupEditing, action: \.transferGroupEditing) { TransferGroupEditing.Reducer() }
		}
	}
}

// MARK: - Transfers actions
private extension TransferList.Reducer {
	func transfersActions (_ action: Transfers.Action, _ state: inout State) -> Effect<Action> {
		switch action {
		case .addTransferGroup(let superTransferGroup):
			addTransferGroup(
				superTransferGroup,
				&state
			)
			
		case .editTransferGroup(let initialTransferGroupContainer, let superTransferGroup):
			editTransferGroup(
				initialTransferGroupContainer,
				superTransferGroup,
				&state
			)
			
		case .addTransfer(superTransferGroup: let superTransferGroup):
			addTransfer(superTransferGroup, &state)
			
		case .editTransfer(initial: let initial, superTransferGroup: let superTransferGroup):
			editTransfer(initial, superTransferGroup, &state)
			
		case .deleteTransfer(let transferUnitId):
			return deleteTransfer(transferUnitId)
		case .deleteTransferGroup(let transferUnitId):
			return deleteTransferGroup(transferUnitId)
		}
		
		return .none
	}
}

// MARK: - Transfer editing actions
private extension TransferList.Reducer {
	func transferEditingActions (_ action: PresentationAction<TransferEditing.Action>, _ state: inout State) -> Effect<Action> {
		switch action {
		case .presented(.onCreationCompleted(let result)) where result.isSuccessful:
			return refresh(&state)
		case .presented(.onUpdatingCompleted(let result)) where result.isSuccessful:
			return refresh(&state)
		default:
			return .none
		}
	}
}

// MARK: - Transfer group editing actions
private extension TransferList.Reducer {
	func transferGroupEditingActions (_ action: PresentationAction<TransferGroupEditing.Action>, _ state: inout State) -> Effect<Action> {
		switch action {
		case .presented(.onCreationCompleted(let result)) where result.isSuccessful:
			return refresh(&state)
		case .presented(.onUpdatingCompleted(let result)) where result.isSuccessful:
			return refresh(&state)
		default:
			return .none
		}
	}
}

// MARK: - Action handlers
private extension TransferList.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		loadTransfers(&state)
	}
	
	func refresh (_ state: inout State) -> Effect<Action> {
		loadTransfers(&state)
	}
	
	func onTransfersLoaded (_ transfers: Loadable<[TransferUnit]>, _ state: inout State) {
		state.transfers = transfers.mapValue {
			.init(
				userGroup: state.userGroup,
				superTransferGroup: nil,
				transferUnits: $0
			)
		}
	}
	
	func onTransferGroupCreateButtonTap (_ state: inout State) {
		state.transferGroupEditing = .creation(
			superTransferGroupId: nil,
			userGroup: state.userGroup,
			sharedInfo: .init(currency: .eur)
		)
	}
	
	func onTransferCreateButtonTap (_ state: inout State) {
		state.transferEditing = .creation(
			superTransferGroupId: nil,
			userGroup: state.userGroup,
			initialCreditor: nil,
			remainingAmountValue: nil
		)
	}
}

// MARK: - Transfers action handlers
private extension TransferList.Reducer {
	func addTransfer (
		_ superTransferGroup: TransferGroup?,
		_ state: inout State
	) {
		state.transferEditing = .creation(
			superTransferGroupId: superTransferGroup?.id,
			userGroup: state.userGroup,
			initialCreditor: nil,
			remainingAmountValue: nil
		)
	}

	func addTransferGroup (
		_ superTransferGroup: TransferGroup?,
		_ state: inout State
	) {
		state.transferGroupEditing = .creation(
			superTransferGroupId: superTransferGroup?.id,
			userGroup: state.userGroup,
			sharedInfo: .init(currency: .eur)
		)
	}
	
	func editTransfer (
		_ initialTransfer: Transfer,
		_ superTransferGroup: TransferGroup?,
		_ state: inout State
	) {
		state.transferEditing = .updating(
			initialTransferUnit: .init(transfer: initialTransfer),
			superTransferGroupId: superTransferGroup?.id,
			userGroup: state.userGroup
		)
	}

	func editTransferGroup (
		_ initialTransferGroupContainer: TransferGroup.Container,
		_ superTransferGroup: TransferGroup?,
		_ state: inout State
	) {
		state.transferGroupEditing = .updating(
			initialTransferGroupContainer: initialTransferGroupContainer,
			superTransferGroupId: superTransferGroup?.id,
			userGroup: state.userGroup
		)
	}

	func editTransferSplitGroup (
		_ initialTransferSplitGroup: TransferSplitGroup,
		_ superTransferGroup: TransferGroup?,
		_ state: inout State
	) {
		state.transferEditing = .updating(
			initialTransferUnit: .init(transferSplitGroup: initialTransferSplitGroup),
			superTransferGroupId: superTransferGroup?.id,
			userGroup: state.userGroup
		)
	}
	
	func deleteTransfer (_ transferUnitId: UUID) -> Effect<Action> {
		.run { _ in
			try await transferService.deleteTransfer(id: transferUnitId)
		}
	}
	
	func deleteTransferGroup (_ transferUnitId: UUID) -> Effect<Action> {
		.run { _ in
			try await transferService.deleteTransferGroup(id: transferUnitId)
		}
	}
}

// MARK: - Functions
private extension TransferList.Reducer {
	func loadTransfers (_ state: inout State) -> Effect<Action> {
		state.transfers = .loading()
		
		return .run { [state] send in
			let transfers = await Loadable { try await userGroupService.transfers(userGroupId: state.userGroup.id) }
			await send(.onTransfersLoaded(transfers))
		}
	}
}
