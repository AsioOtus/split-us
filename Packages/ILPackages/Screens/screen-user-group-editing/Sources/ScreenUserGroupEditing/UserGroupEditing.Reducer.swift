import ComposableArchitecture
import Foundation
import Multitool
import DLServices

// MARK: - Body
extension UserGroupEditing {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = UserGroupEditing.State
		public typealias Action = UserGroupEditing.Action

		@Dependency(\.dismiss) var dismiss
		@Dependency(\.usersService) var usersService
		@Dependency(\.userGroupsService) var userGroupsService

		public init () { }

		public var body: some ComposableArchitecture.Reducer<State, Action> {
			BindingReducer()

			Reduce { state, action in
				switch action {
				case .binding:
					break

				case .initialize:
					return initialize(&state)

				case .onSaveButtonTap:
					return onSaveButtonTap(&state)

				case .onCancelButtonTap:
					return onCancelButtonTap(&state)

				case .onUserGroupSavingFinished(let result):
					return onUserGroupSavingFinished(result, &state)
				}

				return .none
			}
		}
	}
}

// MARK: - Action handlers
private extension UserGroupEditing.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		.none
	}

	func onSaveButtonTap (_ state: inout State) -> Effect<Action> {
		.none
	}

	func onCancelButtonTap (_ state: inout State) -> Effect<Action> {
		.run { _ in await dismiss() }
	}

	func onUserGroupSavingFinished (_ result: Loadable<None>, _ state: inout State) -> Effect<Action> {
		if result.isSuccessful {
			return .run { _ in await dismiss() }
		} else {
			state.savingUserGroupRequest = result
			return .none
		}
	}
}

// MARK: - Functions
private extension UserGroupEditing.Reducer {

}
