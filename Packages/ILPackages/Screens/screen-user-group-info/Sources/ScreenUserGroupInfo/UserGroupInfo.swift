import ComposableArchitecture
import ScreenUserGroupEditing
import ScreenUserGroupUserAdding
import DLModels
import DLUtils

// MARK: - Feature
public enum UserGroupInfo { }

// MARK: - State
extension UserGroupInfo {
	@ObservableState
	public struct State: Equatable {
		var userGroup: Loadable<UserGroup>
		var users: Loadable<[User.Compact]> = .initial()

		@Presents var userGroupEditing: UserGroupEditing.State?
		@Presents var userGroupUsersAdding: UserGroupUsersAdding.State?

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

		case userGroupEditing(PresentationAction<UserGroupEditing.Action>)
		case userGroupUsersAdding(PresentationAction<UserGroupUsersAdding.Action>)
	}
}
