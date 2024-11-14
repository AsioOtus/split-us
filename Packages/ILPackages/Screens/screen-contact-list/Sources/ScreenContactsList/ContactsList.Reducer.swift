import ComposableArchitecture
import DLModels
import Foundation
import Multitool
import ScreenAddContacts
import ScreenUserProfile

extension ContactsList {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = ContactsList.State
		public typealias Action = ContactsList.Action
		
		@Dependency(\.usersService) var usersService
		@Dependency(\.userLocalService) var userLocalService

		public init () { }
		
		public var body: some ReducerOf<Self> {
			Reduce { state, action in
				switch action {
				case .initialize: return initialize(&state)
				case .refresh: return refresh(&state)
					
				case .onContactTap(userId: let userId): onContactTap(userId, &state)
				case .onAddContactScreenButtonTap: onAddContactButtonTap(&state)
				case .onContactsLoaded(let contacts): onContactsLoaded(contacts, &state)
				case .onRemoveContactButtonTap(userId: let userId): return onRemoveContactButtonTap(userId: userId, &state)
				case .onContactRemovingCompleted(userId: let userId): onContactRemovingCompleted(userId, &state)
					
				case .addContact(.presented(.finished)): fallthrough
				case .addContact(.dismiss): return onAddContactFinished(&state)
				case .addContact: break
					
				case .contactDetails: break
				}
				
				return .none
			}
			.ifLet(\.$addContact, action: \.addContact) {
				AddContacts.Reducer()
			}
			.ifLet(\.$contactDetails, action: \.contactDetails) {
				UserProfile.Reducer()
			}
		}
	}
}

private extension ContactsList.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		loadLocalContacts(&state)
		return loadContacts(&state)
	}
	
	func refresh (_ state: inout State) -> Effect<Action> {
		loadContacts(&state)
	}
	
	func onContactTap (_ userId: UUID, _ state: inout State) {
		state.contactDetails = .init(userId: userId)
	}

	func onAddContactButtonTap (_ state: inout State) {
		state.addContact = .init()
	}
	
	func onAddContactFinished (_ state: inout State) -> Effect<Action> {
		state.addContact = nil
		return loadContacts(&state)
	}
	
	func onContactsLoaded (_ contacts: Loadable<[User.Compact]>, _ state: inout State) {
		state.contacts = contacts
	}
	
	func onRemoveContactButtonTap (userId: UUID, _ state: inout State) -> Effect<Action> {
		state.contacts = state.contacts.mapValue { $0.filter { $0.id != userId } }
		state.removeRequests = []
		
		return .run { send in
			try await usersService.removeContact(userId: userId)
			await send(.onContactRemovingCompleted(userId: userId))
		}
	}
	
	func onContactRemovingCompleted (_ userId: UUID, _ state: inout State) {
		state.removeRequests = []
	}
}

private extension ContactsList.Reducer {
	func loadLocalContacts (_ state: inout State) {
		guard
			let users = try? userLocalService.contacts(page: .init(number: 0, size: 100)),
			!users.isEmpty
		else { return }

		state.contacts = .successful(users)
	}

	func loadContacts (_ state: inout State) -> Effect<Action> {
		state.contacts.setLoading()
		
		return .run { send in
			let contacts = await Loadable.result {
				try await usersService.contacts(page: .init(number: 0, size: 100))
			}
			
			await send(.onContactsLoaded(contacts))
		}
	}
}
