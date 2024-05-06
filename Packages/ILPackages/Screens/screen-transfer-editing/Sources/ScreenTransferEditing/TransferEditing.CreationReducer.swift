import ComposableArchitecture
import DLServices
import DLModels
import DLUtils

// MARK: - Body
extension TransferEditing {
	public struct CreationReducer: ComposableArchitecture.Reducer {
		@Dependency(\.dismiss) var dismiss
		
		@Dependency(\.transferService) var transferService
		
		public init () { }
		
		public var body: some ComposableArchitecture.Reducer<State, Action> {
			Reduce { state, action in
				guard state.isCreation else { return .none }
				
				switch action {
				case .onSubmitButtonTap: return onSubmitButtonTap(&state)
				case .onCreationCompleted(let transferUnit): return onCreationCompleted(transferUnit, &state)
				default: break
				}
				
				return .none
			}
		}
	}
}

// MARK: - Action handlers
private extension TransferEditing.CreationReducer {
	func onSubmitButtonTap (_ state: inout State) -> Effect<Action> {
		if state.isLocal {
			createLocalTransfer(&state)
		} else {
			createOnlineTransfer(&state)
		}
	}
	
	func onCreationCompleted (
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
private extension TransferEditing.CreationReducer {
	func createOnlineTransfer (_ state: inout State) -> Effect<Action> {
		let transfer = Transfer.New(
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
		
		return .run { [state] send in
			let transfer = await Loadable {
				try await transferService
					.createTransfer(
						transfer: transfer,
						transferGroupId: state.superTransferGroupId,
						userGroupId: state.userGroup.id
					)
			}
			.mapValue(TransferUnit.init(transfer:))

			await send(.onCreationCompleted(transfer))
		}
	}
	
	func createOnlineTransferSplitGroup (_ state: inout State) -> Effect<Action> {
//		let borrowerAmounts = state
//			.amountSplitState?
//			.selectedUsers
//			.map { ($0.id, $0.amount) } ?? []

		let transferSplitGroup = TransferSplitGroup.New(
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
		
		return .run { [state] send in
			let transferGroup = await Loadable {
				try await transferService
					.createTransferSplitGroup(
						transferSplitGroup: transferSplitGroup,
						superTransferGroupId: state.superTransferGroupId,
						userGroupId: state.userGroup.id
					)
			}
			.mapValue(TransferUnit.init(transferSplitGroup:))

			await send(.onCreationCompleted(transferGroup))
		}
	}
	
	func createLocalTransfer (_ state: inout State) -> Effect<Action> {
		let transfer = Transfer(
			id: .init(),
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
			await send(.onCreationCompleted(.successful(.init(transfer: transfer))))
		}
	}
	
	func createLocalTransferSplitGroup (_ state: inout State) -> Effect<Action> {
//		let borrowerAmounts = state
//			.amountSplitState?
//			.selectedUsers
//			.map { ($0.user, $0.amount) } ?? []

		let transferSplitGroup = TransferSplitGroup(
			id: .init(),
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
			await send(.onCreationCompleted(.successful(.init(transferSplitGroup: transferSplitGroup))))
		}
	}
}
