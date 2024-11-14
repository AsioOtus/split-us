import ComponentsTCAGeneral
import ComposableArchitecture
import Foundation
import DLModels
import DLServices
import Multitool
import ScreenUserGroupCreation
import ScreenUserGroupDetails
import ScreenUserGroupInfo

public enum UserGroups { }

extension UserGroups {
	@ObservableState
	public struct State {
		var userGroups: PageLoading<UserGroup>.State = .init(loadingId: .zeros)

		@Presents var creation: UserGroupCreation.State?
		@Presents var userGroupDetails: UserGroupDetails.State?

		public init () { }
	}
}

extension UserGroups.State: Equatable {
	public static func == (lhs: UserGroups.State, rhs: UserGroups.State) -> Bool {
		lhs.creation == rhs.creation && lhs.userGroupDetails == rhs.userGroupDetails
	}
}

extension UserGroups {
	@CasePathable
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		
		case initialize
		case refresh

		case onUserGroupSelected(UserGroup)
		case onPinButtonTapped(userGroupId: UUID)

		case onUserGroupsLoaded(Loadable<[UserGroup]>)
		case onCreateButtonTap
		
		case userGroups(PageLoading<UserGroup>.Action)
		case creation(PresentationAction<UserGroupCreation.Action>)
		case userGroupDetails(PresentationAction<UserGroupDetails.Action>)
	}
}
