import ComposableArchitecture
import DLModels

public enum UserEjectSelection { }

extension UserEjectSelection {
	@ObservableState
	public struct State: Equatable {
		public var unselectedUsers: [User.Compact]
		public var selectedUsers: [User.Compact]

		public init (
			unselectedUsers: [User.Compact],
			selectedUsers: [User.Compact]
		) {
			self.unselectedUsers = unselectedUsers
			self.selectedUsers = selectedUsers
		}
	}
}

extension UserEjectSelection {
	@CasePathable
	public enum Action {
		case onUserSelected(User.Compact)
		case onUserDeselected(User.Compact)
	}
}
