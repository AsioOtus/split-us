import ComposableArchitecture
import Foundation
import ScreenUserGroupCreation
import ScreenUserGroupDetails
import ScreenUserGroupInfo
import DLServices
import DLModels
import DLUtils

public enum UserGroups { }

extension UserGroups {
	@ObservableState
	public struct State: Equatable {
		let currentUser: User
		var userGroups: Loadable<[UserGroup]> = .initial()
		
		@Presents var creation: UserGroupCreation.State?
		@Presents var userGroupDetails: UserGroupDetails.State?

		public init (currentUser: User) {
			self.currentUser = currentUser
		}
	}
}

extension UserGroups {
	@CasePathable
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		
		case initialize
		case refresh

		case onUserGroupSelected(UserGroup)

		case onUserGroupsLoaded(Loadable<[UserGroup]>)
		case onCreateButtonTap
		
		case creation(PresentationAction<UserGroupCreation.Action>)
		case userGroupDetails(PresentationAction<UserGroupDetails.Action>)
	}
}
