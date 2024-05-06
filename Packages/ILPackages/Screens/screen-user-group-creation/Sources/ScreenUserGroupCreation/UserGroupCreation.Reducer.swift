import ComposableArchitecture
import Multitool
import DLServices
import DLModels
import UserComponents
import DLUtils

extension UserGroupCreation {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = UserGroupCreation.State
		public typealias Action = UserGroupCreation.Action

		@Dependency(\.dismiss) var dismiss
		@Dependency(\.usersService) var usersService
		@Dependency(\.userGroupsService) var userGroupsService
		@Dependency(\.userGroupNameValidationService) var userGroupNameValidationService

		public init () { }

		public var body: some ReducerOf<Self> {
			BindingReducer()

			Reduce { state, action in
				switch action {
				case .initialize: return initialize(&state)
				case .onCreateButtonTap: return onCreateButtonTap(&state)
				case .onCancelButtonTap: return onCancelButtonTap()
				case .onContactsLoaded(let contacts): onContactsLoaded(contacts, &state)
				case .onUserGroupCreationFinished(let result): return onUserGroupCreationFinished(result, &state)
				default: break
				}

				return .none
			}

			Scope(state: \.contactsSelection, action: \.contactsSelection) {
				EmptyReducer()
					.ifCaseLet(\.successful, action: \.self) {
						UserEjectSelection.Reducer()
					}
			}
		}
	}
}

private extension UserGroupCreation.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		loadContacts(&state)
	}

	func onCreateButtonTap (_ state: inout State) -> Effect<Action> {
		state.isUserGroupNameValidationRequired = true

		guard let selectedUsers = state.contactsSelection.value?.selectedUsers else { return .none }
		guard !state.userGroupName.isEmpty else { return .none }

		state.isUserGroupNameValidationRequired = false

		return createUserGroup(selectedUsers, &state)
	}

	func onCancelButtonTap () -> Effect<Action> {
		.run { _ in await dismiss() }
	}

	func onContactsLoaded (_ contacts: Loadable<[User.Compact]>, _ state: inout State) {
		state.contactsSelection = contacts.mapValue { .init(unselectedUsers: $0, selectedUsers: []) }
	}

	func onUserGroupCreationFinished (_ result: Loadable<None>, _ state: inout State) -> Effect<Action> {
		if result.isSuccessful {
			return .run { _ in
				await dismiss()
			}
		} else {
			state.createUserGroupRequest = result
			return .none
		}
	}
}

private extension UserGroupCreation.Reducer {
	func createUserGroup (_ selectedUsers: [User.Compact], _ state: inout State) -> Effect<Action> {
		state.createUserGroupRequest = .loading()

		return .run { [state] send in
			let creationResult = await Loadable.result {
				try await userGroupsService.create(name: state.userGroupName, users: selectedUsers)
			}
				.replaceWithNone()

			await send(.onUserGroupCreationFinished(creationResult))
		}
	}

	func loadContacts (_ state: inout State) -> Effect<Action> {
		state.contactsSelection = .loading()

		return .run { send in
			let contacts = await Loadable.result { try await usersService.contacts() }
			await send(.onContactsLoaded(contacts))
		}
	}
}
