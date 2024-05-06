import ComposableArchitecture
import DLModels
import DLUtils

// MARK: - Body
extension UserDetails {
	public struct Reducer: ComposableArchitecture.Reducer {
		@Dependency(\.usersService) var usersService

		public init () { }

		public var body: some ComposableArchitecture.Reducer<State, Action> {
			Reduce { state, action in
				switch action {
				case .initialize: return initialize(&state)
				case .refresh: return initialize(&state)

				case .onUserLoadingCompleted(let user): onUserLoadingCompleted(user, &state)
				}

				return .none
			}
		}
	}
}

// MARK: - Action handlers
private extension UserDetails.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		loadUser(&state)
	}

	func refresh (_ state: inout State) -> Effect<Action> {
		loadUser(&state)
	}

	func onUserLoadingCompleted (_ user: Loadable<User.Compact>, _ state: inout State) {
		state.user = user
	}
}

// MARK: - Functions
private extension UserDetails.Reducer {
	func loadUser (_ state: inout State) -> Effect<Action> {
		state.user.setLoading()

		return .run { [state] send in
			let user = await Loadable {
				try await usersService.userDetails(userId: state.userId)
			}

			await send(.onUserLoadingCompleted(user))
		}
	}
}
