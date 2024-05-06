import ComposableArchitecture
import Foundation
import ScreenUserGroupEditing
import ScreenUserGroupUserAdding
import DLModels
import DLUtils

// MARK: - Body
extension UserGroupInfo {
	public struct Reducer: ComposableArchitecture.Reducer {
		@Dependency(\.userGroupsService) var userGroupsService
		
		public init () { }
		
		public var body: some ComposableArchitecture.Reducer<State, Action> {
			Reduce { state, action in
				switch action {
				case .initialize:
					return initialize(&state)
					
				case .onUsersLoaded(let users):
					onUsersLoaded(users, &state)
					
				case .onEditUserGroupButtonTap:
					onEditUserGroupButtonTap(&state)
					
				case .onAddUsersButtonTap:
					onAddUsersButtonTap(&state)
					
				case .userGroupEditing:
					break
					
				case .userGroupUsersAdding(.dismiss):
					return onUserGroupUsersAddingDismiss(&state)
					
				case .userGroupUsersAdding:
					break
				}
				
				return .none
			}
			.ifLet(\.$userGroupEditing, action: /Action.userGroupEditing) {
				UserGroupEditing.Reducer()
			}
			.ifLet(\.$userGroupUsersAdding, action: /Action.userGroupUsersAdding) {
				UserGroupUsersAdding.Reducer()
			}
		}
	}
}

// MARK: - Action handlers
private extension UserGroupInfo.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		if let userGroupId = state.userGroup.value?.id {
			return loadUsers(userGroupId, &state)
		}
		
		return .none
	}
	
	func onUsersLoaded (_ users: Loadable<[User.Compact]>, _ state: inout State) {
		state.users = users
	}
	
	func onEditUserGroupButtonTap (_ state: inout State) {
		guard let userGroup = state.userGroup.value else { return }
		state.userGroupEditing = .init(userGroupId: userGroup.id)
	}
	
	func onAddUsersButtonTap (_ state: inout State) {
		guard let userGroupId = state.userGroup.value?.id else { return }
		state.userGroupUsersAdding = .init(userGroupId: userGroupId)
	}
	
	func onUserGroupUsersAddingDismiss (_ state: inout State) -> Effect<Action> {
		guard let userGroupId = state.userGroup.value?.id else { return .none }
		return loadUsers(userGroupId, &state)
	}
}

// MARK: - Functions
private extension UserGroupInfo.Reducer {
	func loadUsers (_ userGroupId: UUID, _ state: inout State) -> Effect<Action> {
		state.users = state.users.loading()
		
		return .run { send in
			let users = await Loadable { try await userGroupsService.users(userGroupId: userGroupId) }
			await send(.onUsersLoaded(users))
		}
	}
}
