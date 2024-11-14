import ComposableArchitecture
import DLModels
import Foundation
import Multitool
import ScreenUserGroupEditing
import ScreenUserGroupUserAdding
import ScreenUserProfile

// MARK: - Feature
public enum UserGroupInfo { }

// MARK: - State
extension UserGroupInfo {
	@ObservableState
	public struct State: Equatable {
		var userGroup: Loadable<UserGroup>
		var users: Loadable<[User.Compact]> = .initial

		@Presents var userGroupEditing: UserGroupEditing.State?
		@Presents var userGroupUsersAdding: UserGroupUsersAdding.State?
		@Presents var userProfile: UserProfile.State?

		public init (userGroup: UserGroup) {
			self.userGroup = .successful(userGroup)
		}
	}
}

// MARK: - Action
extension UserGroupInfo {
	@CasePathable
	public enum Action {
		case initialize

		case onUsersLoaded(Loadable<[User.Compact]>)

		case onEditUserGroupButtonTap
		case onAddUsersButtonTap
		case onUserTap(userId: UUID)

		case userGroupEditing(PresentationAction<UserGroupEditing.Action>)
		case userGroupUsersAdding(PresentationAction<UserGroupUsersAdding.Action>)
		case userProfile(PresentationAction<UserProfile.Action>)
	}
}
