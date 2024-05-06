import ComposableArchitecture
import Foundation
import Multitool
import DLServices
import DLUtils

// MARK: - Feature
public enum UserGroupEditing { }

// MARK: - State
extension UserGroupEditing {
	@ObservableState
	public struct State: Equatable {
		let userGroupId: UUID
		
		var userGroupName = ""
		var isUserGroupNameValidationRequired = false
		
		var savingUserGroupRequest: Loadable<None> = .initial()
		
		public init (userGroupId: UUID) {
			self.userGroupId = userGroupId
		}
	}
}

// MARK: - Action
extension UserGroupEditing {
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		
		case initialize
		case onSaveButtonTap
		case onCancelButtonTap
		
		case onUserGroupSavingFinished(Loadable<None>)
	}
}
