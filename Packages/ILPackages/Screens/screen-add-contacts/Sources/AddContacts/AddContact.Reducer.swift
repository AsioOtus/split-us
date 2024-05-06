import ComposableArchitecture
import Foundation
import Multitool
import DLServices
import DLModels
import DLUtils

extension AddContacts {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = AddContacts.State
		public typealias Action = AddContacts.Action
		
		@Dependency(\.dismiss) var dismiss
		@Dependency(\.usersService) var userService
		
		public init () { }
		
		public var body: some ComposableArchitecture.Reducer<State, Action> {
			BindingReducer()
			
			Reduce { state, action in
				switch action {
				case .binding:
					break
					
				case .initialize:
					break
				case .finished:
					break
					
				case .onSearchButtonTap:
					return onSearchButtonTap(&state)
				case .onCancelButtonTap:
					return onCancelButtonTap()
				case .onAddContactsButtonTap(userId: let userId):
					return onAddContactsButtonTap(userId: userId, &state)
				case .onRemoveContactButtonTap(userId: let userId):
					return onRemoveContactButtonTap(userId: userId, &state)
					
				case .onSearchResultLoaded(let user):
					onSearchResultLoaded(user, &state)
				case .onContactAddingCompleted(let result):
					onContactAddingCompleted(result: result, &state)
				case .onContactRemovingCompleted(let result):
					onContactRemovingCompleted(result: result, &state)
				}
				
				return .none
			}
		}
	}
}

private extension AddContacts.Reducer {
	func onSearchButtonTap (_ state: inout State) -> Effect<Action> {
		search(&state)
	}
	
	func onCancelButtonTap () -> Effect<Action> {
		.send(.finished)
	}
	
	func onAddContactsButtonTap (userId: UUID, _ state: inout State) -> Effect<Action> {
		state.addRemoveRequest = .loading()
		
		return .run { send in
			let addingResult = await Loadable
				.result { try await userService.addContact(userId: userId) }
				.replaceWithNone()
			
			await send(.onContactAddingCompleted(addingResult))
		}
	}
	
	func onRemoveContactButtonTap (userId: UUID, _ state: inout State) -> Effect<Action> {
		state.addRemoveRequest = .loading()
		
		return .run { send in
			let addingResult = await Loadable
				.result { try await userService.removeContact(userId: userId) }
				.replaceWithNone()
			
			await send(.onContactRemovingCompleted(addingResult))
		}
	}
	
	func onSearchResultLoaded (_ user: Loadable<User.ContactSearch?>, _ state: inout State) {
		state.searchResult = user
	}
	
	func onContactAddingCompleted (result: Loadable<None>, _ state: inout State) {
		state.addRemoveRequest = result
		
		if result.isSuccessful {
			state.searchResult = state.searchResult.mapSuccessfulValue {
				$0.map { User.ContactSearch(user: $0.user, isContact: true) }
			}
		}
	}
	
	func onContactRemovingCompleted (result: Loadable<None>, _ state: inout State) {
		state.addRemoveRequest = result
		
		if result.isSuccessful {
			state.searchResult = state.searchResult.mapSuccessfulValue {
				$0.map { User.ContactSearch(user: $0.user, isContact: false) }
			}
		}
	}
}

private extension AddContacts.Reducer {
	func search (_ state: inout State) -> Effect<Action> {
		state.searchResult = .loading()
		
		return .run { [state] send in
			let user = await Loadable.result { try await userService.search(username: state.username) }
			await send(.onSearchResultLoaded(user))
		}
	}
}
