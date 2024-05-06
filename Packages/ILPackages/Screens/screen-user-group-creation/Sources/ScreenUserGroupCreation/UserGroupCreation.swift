import ComposableArchitecture
import Multitool
import DLModels
import UserComponents
import DLUtils

public enum UserGroupCreation { }

extension UserGroupCreation {
	@ObservableState
	public struct State: Equatable {
		var userGroupName = ""
		var isUserGroupNameValidationRequired = false
		
		var contactsSelection: Loadable<UserEjectSelection.State> = .initial()
		var createUserGroupRequest: Loadable<None> = .initial()
		
		public init () { }
	}
}

extension UserGroupCreation {
	@CasePathable
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		
		case initialize
		case onCreateButtonTap
		case onCancelButtonTap
		
		case onContactsLoaded(Loadable<[User.Compact]>)
		case onUserGroupCreationFinished(Loadable<None>)
		
		case contactsSelection(UserEjectSelection.Action)
	}
}
