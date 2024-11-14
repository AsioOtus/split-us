import ComposableArchitecture
import DLModels
import DLServices
import Foundation
import Multitool

// MARK: - Body
extension AddRemoveContactButton {
	public struct Reducer: ComposableArchitecture.Reducer {
		@Dependency(\.usersService) var userService

		public init () { }

		public var body: some ComposableArchitecture.Reducer<State, Action> {
			Reduce { state, action in
				switch action {
				case .onAddContactsButtonTap: return onAddContactsButtonTap(&state)
				case .onRemoveContactButtonTap: return onRemoveContactButtonTap(&state)

				case .onContactAddingCompleted(let result): onContactAddingCompleted(result, &state)
				case .onContactRemovingCompleted(let result): onContactRemovingCompleted(result, &state)
				}

				return .none
			}
		}
	}
}

// MARK: - Action handlers
private extension AddRemoveContactButton.Reducer {
	func onAddContactsButtonTap (_ state: inout State) -> Effect<Action> {
		state.request = .loading()

		return .run { [userId = state.userId] send in
			let addingResult = await Loadable
				.result { try await userService.addContact(userId: userId) }
				.replaceWithNone()

			await send(.onContactAddingCompleted(addingResult))
		}
	}

	func onRemoveContactButtonTap (_ state: inout State) -> Effect<Action> {
		state.request = .loading()

		return .run { [userId = state.userId] send in
			let addingResult = await Loadable
				.result { try await userService.removeContact(userId: userId) }
				.replaceWithNone()

			await send(.onContactRemovingCompleted(addingResult))
		}
	}

	func onContactAddingCompleted (_ result: Loadable<None>, _ state: inout State) {
		state.request = result

		if result.isSuccessful {
			state.isContact = true
		}
	}

	func onContactRemovingCompleted (_ result: Loadable<None>, _ state: inout State) {
		state.request = result

		if result.isSuccessful {
			state.isContact = false
		}
	}
}
