import ComposableArchitecture
import ComponentsTCAUser
import DLServices
import DLModels
import ILUtilsTCA
import Multitool

// MARK: - Body
extension UserGroupUsersAdding {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = UserGroupUsersAdding.State
		public typealias Action = UserGroupUsersAdding.Action

		@Dependency(\.dismiss) var dismiss
		@Dependency(\.usersService) var usersService
		@Dependency(\.userGroupsService) var userGroupsService
		
		public init () { }
		
		public var body: some ReducerOf<Self> {
			Reduce { state, action in
				switch action {
				case .initialize:
					return initialize(&state)
					
				case .refresh:
					return refresh(&state)
					
				case .onCancelButtonTap:
					return onCancelButtonTap(&state)
					
				case .onAddButtonTap:
					return onAddButtonTap(&state)
					
				case .onContactsLoaded(let contacts):
					onContactsLoaded(contacts, &state)
					
				case .onUsersAdded(let result):
					return onUsersAdded(result, &state)
					
				case .contactsSelection:
					break
				}
				
				return .none
			}

			Scope(state: \.contactsSelection[case: \.successful], action: \.contactsSelection) {
				UserEjectSelection.Reducer()
			}
		}
	}
}

// MARK: - Action handlers
private extension UserGroupUsersAdding.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		loadContacts(&state)
	}
	
	func refresh (_ state: inout State) -> Effect<Action> {
		loadContacts(&state)
	}
	
	func onCancelButtonTap (_ state: inout State) -> Effect<Action> {
		.run { _ in await dismiss() }
	}
	
	func onAddButtonTap (_ state: inout State) -> Effect<Action> {
		guard let selectedUserIds = state.contactsSelection.value?.selectedUsers.map(\.id)
		else { return .none }
		
		state.usersAddingRequest.setLoading()
		
		return .run { [state] send in
			let result = await Loadable {
				try await userGroupsService.addUsersToUserGroup(
					userIds: selectedUserIds,
					userGroupId: state.userGroupId
				)
			}
				.replaceWithNone()
			
			await send(.onUsersAdded(result))
		}
	}
	
	func onContactsLoaded (_ contacts: Loadable<[User.Compact]>, _ state: inout State) {
		state.contactsSelection = contacts.mapValue { .init(unselectedUsers: $0, selectedUsers: []) }
	}
	
	func onUsersAdded (_ result: Loadable<None>, _ state: inout State) -> Effect<Action> {
		if result.isSuccessful {
			return .run { _ in await dismiss() }
		} else {
			state.usersAddingRequest = result
			return .none
		}
	}
}

// MARK: - Functions
private extension UserGroupUsersAdding.Reducer {
	func loadContacts (_ state: inout State) -> Effect<Action> {
		state.contactsSelection.setLoading()
		
		return .run { send in
			let contacts = await Loadable { try await usersService.contacts(page: .init(number: 0, size: 100)) }
			await send(.onContactsLoaded(contacts))
		}
	}
}
