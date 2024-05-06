import ComposableArchitecture
import DLServices
import DLModels
import DLUtils

// MARK: - Body
extension TransferGroupEditing {
	struct CreationReducer: ComposableArchitecture.Reducer {
		@Dependency(\.dismiss) var dismiss
		@Dependency(\.transferService) var transferService
		
		public init () { }
		
		public var body: some ComposableArchitecture.Reducer<State, Action> {
			Reduce { state, action in
				guard state.isCreation else { return .none }
				
				switch action {
				case .onSubmitButtonTap:
					return onSubmitButtonTap(&state)
					
				case .onCreationCompleted(.successful):
					return onCreationCompleted(&state)
					
				default: break
				}
				
				return .none
			}
		}
	}
}

// MARK: - Action handlers
private extension TransferGroupEditing.CreationReducer {
	func onSubmitButtonTap (_ state: inout State) -> Effect<Action> {
		if state.isLocal {
			createLocalTransferGroup(&state)
		} else {
			createOnlineTransferGroup(&state)
		}
	}
	
	func onCreationCompleted (_ state: inout State) -> Effect<Action> {
		.run { _ in await dismiss() }
	}
}

// MARK: - Functions
private extension TransferGroupEditing.CreationReducer {
	func createOnlineTransferGroup (_ state: inout State) -> Effect<Action> {
		guard
			let transferUnits = state.transferUnits.value
		else { return .none }
		
		let newTransferGroupContainer = TransferGroup.New.Container(
			transferGroup: .init(info: .init(
				name: state.name,
				note: state.note,
				date: state.date
			)),
			transferUnits: transferUnits.map(\.new)
		)
		
		state.submitRequest.setLoading()
		
		return .run { [state] send in
			let transferGroupContainer = await Loadable {
				try await transferService.createTransferGroup(
					transferGroupContainer: newTransferGroupContainer,
					superTransferGroupId: state.superTransferGroupId,
					userGroupId: state.userGroup.id
				)
			}
			
			await send(.onCreationCompleted(transferGroupContainer))
		}
	}
	
	func createLocalTransferGroup (_ state: inout State) -> Effect<Action> {
		guard
			let transferUnits = state.transferUnits.value
		else { return .none }
		
		let newTransferGroupContainer = TransferGroup.Container(
			transferGroup: .init(
				id: .init(),
				info: .init(
					name: state.name,
					note: state.note,
					date: state.date
				)
			),
			transferUnits: transferUnits
		)
		
		return .run { send in
			await send(.onCreationCompleted(.successful(newTransferGroupContainer)))
		}
	}
}
