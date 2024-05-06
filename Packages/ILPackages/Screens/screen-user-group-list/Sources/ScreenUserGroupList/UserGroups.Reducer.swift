import ComposableArchitecture
import Foundation
import ScreenUserGroupCreation
import ScreenUserGroupDetails
import DLServices
import DLModels
import DLUtils

extension UserGroups {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = UserGroups.State
		public typealias Action = UserGroups.Action

		@Dependency(\.userGroupsService) var userGroupService
		
		public init () { }
		
		public var body: some ReducerOf<Self> {
			BindingReducer()
			
			Reduce { state, action in
				switch action {
				case .binding: break

				case .initialize:
					return initialize(&state)
				case .refresh: return refresh(&state)

				case .onUserGroupsLoaded(let userGroups): onUserGroupsLoaded(userGroups, &state)
				case .onCreateButtonTap: onCreateButtonTap(&state)

				case .creation(.dismiss): return onUserGroupCreationDismiss(&state)
				case .onUserGroupSelected(let userGroup): onUserGroupSelected(userGroup, &state)
				case .creation: break
				case .userGroupDetails: break
				}
				
				return .none
			}
			.ifLet(\.$creation, action: \.creation) {
				UserGroupCreation.Reducer()
			}
			.ifLet(\.$userGroupDetails, action: \.userGroupDetails) {
				UserGroupDetails.Reducer()
			}
		}
	}
}

private extension UserGroups.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		loadUserGroups(&state)
	}
	
	func refresh (_ state: inout State) -> Effect<Action> {
		loadUserGroups(&state)
	}
	
	func onUserGroupSelected (_ userGroup: UserGroup, _ state: inout State) {
		state.userGroupDetails = .init(
			userGroup: userGroup,
			currentUser: state.currentUser
		)
	}

	func onUserGroupsLoaded (_ userGroups: Loadable<[UserGroup]>, _ state: inout State) {
		state.userGroups = userGroups
	}
	
	func onCreateButtonTap (_ state: inout State) {
		state.creation = .init()
	}
	
	func onUserGroupCreationDismiss (_ state: inout State) -> Effect<Action> {
		loadUserGroups(&state)
	}
}

private extension UserGroups.Reducer {
	func loadUserGroups (_ state: inout State) -> Effect<Action> {
		state.userGroups = state.userGroups.loading()

		return .run { send in
			let userGroups = await Loadable { try await userGroupService.userGroups() }
			
			await send(.onUserGroupsLoaded(userGroups))
		}
	}
}
