import ComposableArchitecture
import Multitool
import Foundation
import DLServices
import DLModels
import UserComponents
import DLUtils

// MARK: - Feature
public enum UserGroupUsersAdding { }

// MARK: - State
extension UserGroupUsersAdding {
	@ObservableState
	public struct State: Equatable {
		var userGroupId: UUID
		var contactsSelection: Loadable<UserEjectSelection.State> = .initial()
		var usersAddingRequest: Loadable<None> = .initial()
		
		public init (userGroupId: UUID) {
			self.userGroupId = userGroupId
		}
	}
}

// MARK: - Action
extension UserGroupUsersAdding {
	@CasePathable
	public enum Action {
		case initialize
		case refresh
		
		case onCancelButtonTap
		case onAddButtonTap
		
		case onContactsLoaded(Loadable<[User.Compact]>)
		case onUsersAdded(Loadable<None>)
		
		case contactsSelection(UserEjectSelection.Action)
	}
}
