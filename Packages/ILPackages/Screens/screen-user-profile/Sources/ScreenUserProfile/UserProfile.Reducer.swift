import ComponentsTCAUser
import ComposableArchitecture
import DLModels
import Multitool

// MARK: - Body
extension UserProfile {
	public struct Reducer: ComposableArchitecture.Reducer {
		@Dependency(\.usersService) var userService

		public init () { }

		public var body: some ComposableArchitecture.Reducer<State, Action> {
			Reduce { state, action in
				switch action {
				case .initialize: return initialize(state)
				case .refresh: return refresh(state)

				case .onUserLoadingCompleted(let user): onUserLoadingCompleted(user, &state)

				case .addRemoveContactButton: break
				}

				return .none
			}
		}
	}
}

// MARK: - Action handlers
private extension UserProfile.Reducer {
	func initialize (_ state: State) -> Effect<Action> {
		loadUser(state)
	}

	func refresh (_ state: State) -> Effect<Action> {
		loadUser(state)
	}

	func onUserLoadingCompleted (_ user: Loadable<User.Contact>, _ state: inout State) {
		state.userDetails = user.mapValue {
			.init(
				user: $0,
				addRemoveContactButton: .init(
					userId: $0.user.id,
					isContact: $0.isContact
				)
			)
		}
	}
}

// MARK: - Functions
private extension UserProfile.Reducer {
	func loadUser (_ state: State) -> Effect<Action> {
		.run { send in
			let userLoadingResult = await Loadable
				.result { try await userService.user(id: state.userId) }
				.mapValue { User.Contact(user: $0, isContact: false) }

			await send(.onUserLoadingCompleted(userLoadingResult))
		}
	}
}
