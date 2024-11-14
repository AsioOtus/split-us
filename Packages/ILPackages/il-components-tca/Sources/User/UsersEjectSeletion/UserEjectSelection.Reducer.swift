import ComposableArchitecture
import DLModels

extension UserEjectSelection {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = UserEjectSelection.State
		public typealias Action = UserEjectSelection.Action

		public init () { }

		public var body: some ComposableArchitecture.Reducer<State, Action> {
			Reduce { state, action in
				switch action {
				case .onUserSelected(let user): onUserSelected(user, &state)
				case .onUserDeselected(let user): onUserDeselected(user, &state)
				}

				return .none
			}
		}
	}
}

private extension UserEjectSelection.Reducer {
	func onUserSelected (_ user: User.Compact, _ state: inout State) {
		state.unselectedUsers.removeAll { $0 == user }
		state.selectedUsers.append(user)
	}

	func onUserDeselected (_ user: User.Compact, _ state: inout State) {
		state.unselectedUsers.append(user)
		state.selectedUsers.removeAll { $0 == user }
	}
}
