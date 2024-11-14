import ComposableArchitecture
import Foundation
import Multitool
import DLServices
import DLModels

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
					
				case .onSearchResultLoaded(let user):
					onSearchResultLoaded(user, &state)
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
	
	func onSearchResultLoaded (_ contact: Loadable<User.Contact?>, _ state: inout State) {
		state.searchResult = contact
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
