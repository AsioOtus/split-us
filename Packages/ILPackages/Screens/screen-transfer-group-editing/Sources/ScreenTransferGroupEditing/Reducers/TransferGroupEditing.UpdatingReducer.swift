import ComposableArchitecture
import DLServices
import DLModels
import DLUtils

// MARK: - Body
extension TransferGroupEditing {
	struct UpdatingReducer: ComposableArchitecture.Reducer {
		@Dependency(\.dismiss) var dismiss
		
		@Dependency(\.transferService) var transferService
		
		var body: some ComposableArchitecture.Reducer<State, Action> {
			Reduce { state, action in
				guard !state.isCreation else { return .none }
				
				switch action {
				case .onSubmitButtonTap:
					return onSubmitButtonTap(&state)
					
				case .onUpdatingCompleted(let transferGroup):
					return onUpdatingCompleted(transferGroup, &state)
					
				default: break
				}
				
				return .none
			}
		}
	}
}

// MARK: - Action handlers
private extension TransferGroupEditing.UpdatingReducer {
	func onSubmitButtonTap (_ state: inout State) -> Effect<Action> {
		if state.isLocal {
			updateLocalTransferGroup(&state)
		} else {
			updateOnlineTransferGroup(&state)
		}
	}
	
	func onUpdatingCompleted (_ transferGroup: Loadable<TransferGroup.Container>, _ state: inout State) -> Effect<Action> {
		if transferGroup.isSuccessful {
			return .run { _ in await dismiss() }
		} else {
			state.submitRequest = transferGroup.replaceWithNone()
			return .none
		}
	}
}

// MARK: - Functions
private extension TransferGroupEditing.UpdatingReducer {
	func updateOnlineTransferGroup (_ state: inout State) -> Effect<Action> {
		guard
			let initialTransferGroupContainer = state.initialTransferGroupContainer
		else { return .none }
		
		let transferGroupInfo = TransferUnit.Info(
			name: state.name,
			note: state.note,
			date: state.date
		)
		
		state.submitRequest.setLoading()
		
		return .run { send in
			let transferGroupContainer = await Loadable {
				try await transferService
					.updateTransferGroupInfo(transferGroupInfo: transferGroupInfo, transferGroupId: initialTransferGroupContainer.transferGroup.id)
			}
			.mapValue {
				TransferGroup.Container(
					transferGroup: .init(
						id: initialTransferGroupContainer.transferGroup.id,
						info: $0
					),
					transferUnits: initialTransferGroupContainer.transferUnits
				)
			}
			
			await send(.onUpdatingCompleted(transferGroupContainer))
		}
	}
	
	func updateLocalTransferGroup (_ state: inout State) -> Effect<Action> {
		guard
			let initialTransferGroupContainer = state.initialTransferGroupContainer,
			let transferUnits = state.transferUnits.value
		else { return .none }
		
		return .run { [state] send in
			let transferGroupContainer = TransferGroup.Container(
				transferGroup: .init(
					id: initialTransferGroupContainer.transferGroup.id,
					info: .init(
						name: state.name,
						note: state.note,
						date: state.date
					)
				),
				transferUnits: transferUnits
			)
			
			await send(.onUpdatingCompleted(.successful(transferGroupContainer)))
		}
	}
}
