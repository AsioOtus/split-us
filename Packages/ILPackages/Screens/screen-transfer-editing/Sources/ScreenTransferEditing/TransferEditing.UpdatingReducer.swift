import ComposableArchitecture
import DLServices
import DLModels
import DLUtils

// MARK: - Body
extension TransferEditing {
	public struct UpdatingReducer: ComposableArchitecture.Reducer {
		@Dependency(\.dismiss) var dismiss
		
		@Dependency(\.transferService) var transferService
		
		public init () { }
		
		public var body: some ComposableArchitecture.Reducer<State, Action> {
			Reduce { state, action in
				guard !state.isCreation else { return .none }
				
				switch action {
				case .onSubmitButtonTap: return onSubmitButtonTap(&state)
				case .onUpdatingCompleted(let transferUnit): return onUpdatingCompleted(transferUnit, &state)
				default: break
				}
				
				return .none
			}
		}
	}
}

// MARK: - Action handlers
private extension TransferEditing.UpdatingReducer {
	func onSubmitButtonTap (_ state: inout State) -> Effect<Action> {
		if state.isLocal {
			updateLocalTransfer(&state)
		} else {
			updateOnlineTransfer(&state)
		}
	}
	
	func onUpdatingCompleted (
		_ transferUnit: Loadable<TransferUnit>,
		_ state: inout State
	) -> Effect<Action> {
		if transferUnit.isSuccessful {
			return .run { _ in await dismiss() }
		} else {
			state.submitRequest = transferUnit.replaceWithNone()
			return .none
		}
	}
}

// MARK: - Functions
private extension TransferEditing.UpdatingReducer {
	func updateOnlineTransferSplitGroup (_ state: inout State) -> Effect<Action> {
		guard let initialTransferGroupId = state.initialTransferUnit?.id else { return .none }
		
//		let borrowerAmounts = state
//			.amountSplitState?
//			.selectedUsers
//			.map { ($0.id, $0.amount) } ?? []

		let transferSplitGroup = TransferSplitGroup.Update(
			id: initialTransferGroupId,
			info: .init(
				name: state.name,
				note: state.note,
				date: state.date
			),
			amountValue: state.totalAmountValue,
			currencyId: state.currency.id,
			creditorId: state.creditor?.id,
			borrowerAmounts: .init(uniqueKeysWithValues: [])
		)

		state.submitRequest.setLoading()
		
		return .run { send in
			let transferSplitGroup = await Loadable {
				try await transferService
					.updateTransferSplitGroup(transferSplitGroup: transferSplitGroup)
			}
			.mapValue(TransferUnit.init(transferSplitGroup:))

			await send(.onUpdatingCompleted(transferSplitGroup))
		}
	}
	
	func updateOnlineTransfer (_ state: inout State) -> Effect<Action> {
		guard let initialTransferUnitId = state.initialTransferUnit?.id else { return .none }
		
		let transfer = Transfer.Update(
			id: initialTransferUnitId,
			info: .init(
				name: state.name,
				note: state.note,
				date: state.date
			),
			amountValue: state.totalAmountValue,
			currencyId: state.currency.id,
			creditorId: state.creditor?.id,
			borrowerId: state.amountValueSplitInteractor?.users.first?.id
		)
		
		return .run { send in
			let transfer = await Loadable {
				try await transferService.updateTransfer(transfer: transfer)
			}
			.mapValue(TransferUnit.init(transfer:))

			await send(.onUpdatingCompleted(transfer))
		}
	}
	
	func updateLocalTransferSplitGroup (_ state: inout State) -> Effect<Action> {
		guard case .transfer(let initialTransferGroup) = state.initialTransferUnit?.value
		else { return .none }
		
//		let borrowerAmounts = state
//			.amountSplitState?
//			.selectedUsers
//			.map { ($0.user, $0.amount) } ?? []

		let transferSplitGroup = TransferSplitGroup(
			id: initialTransferGroup.id,
			info: .init(
				name: state.name,
				note: state.note,
				date: state.date
			),
			amount: .init(
				value: state.totalAmountValue,
				currency: state.currency
			),
			creditor: state.creditor,
			borrowerAmounts: .init(uniqueKeysWithValues: [])
		)

		return .run { send in
			await send(.onUpdatingCompleted(.successful(.init(transferSplitGroup: transferSplitGroup))))
		}
	}
	
	func updateLocalTransfer (_ state: inout State) -> Effect<Action> {
		guard case .transfer(let initialTransfer) = state.initialTransferUnit?.value else { return .none }

		let transfer = Transfer(
			id: initialTransfer.id,
			info: .init(
				name: state.name,
				note: state.note,
				date: state.date
			),
			amount: .init(
				value: state.totalAmountValue,
				currency: state.currency
			),
			creditor: state.creditor,
			borrower: state.amountValueSplitInteractor?.users.first?.user
		)
		
		return .run { send in
			await send(.onUpdatingCompleted(.successful(.init(transfer: transfer))))
		}
	}
}
