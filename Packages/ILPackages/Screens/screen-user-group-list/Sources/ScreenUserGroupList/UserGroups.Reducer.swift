import ComponentsTCAGeneral
import ComposableArchitecture
import Foundation
import DLModels
import DLServices
import Multitool
import ScreenUserGroupCreation
import ScreenUserGroupDetails

extension UserGroups {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = UserGroups.State
		public typealias Action = UserGroups.Action

		@Dependency(\.userGroupsService) var userGroupService
		@Dependency(\.userGroupLocalService) var userGroupLocalService
		@Dependency(\.persistentPinnedUserGroupService) var pinnedUserGroupService

		public init () { }
		
		public var body: some ReducerOf<Self> {
			BindingReducer()
			
			Reduce { state, action in
				switch action {
				case .binding: break

				case .initialize: return initialize(&state)
				case .refresh: return refresh(&state)

				case .onUserGroupsLoaded(let userGroups): break
				case .onCreateButtonTap: onCreateButtonTap(&state)

				case .onUserGroupSelected(let userGroup): onUserGroupSelected(userGroup, &state)
				case .onPinButtonTapped(userGroupId: let userGroupId): break

				case .userGroups(.connectionState(.refresh)): break
				case .userGroups: break

				case .creation(.dismiss): return onUserGroupCreationDismiss(&state)
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

			Scope(state: \.userGroups, action: \.userGroups) {
				PageLoading<UserGroup>.Reducer { _, page in
					try await userGroupService.userGroups()
				} loadPageLocal: { _, page in
					try userGroupLocalService.loadUserGroups(page: page)
				}
			}
		}
	}
}

private extension UserGroups.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		.send(.userGroups(.initialize))
	}
	
	func refresh (_ state: inout State) -> Effect<Action> {
		.send(.userGroups(.refresh))
	}

	func onUserGroupSelected (_ userGroup: UserGroup, _ state: inout State) {
		state.userGroupDetails = .init(userGroup: userGroup)
	}
	
	func onCreateButtonTap (_ state: inout State) {
		state.creation = .init()
	}
	
	func onUserGroupCreationDismiss (_ state: inout State) -> Effect<Action> {
		.send(.userGroups(.refresh))
	}
}
