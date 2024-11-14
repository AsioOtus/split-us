import ComposableArchitecture
import DLModels
import DLServices

// MARK: - Body
extension ConnectionStateFeature {
	public struct Reducer: ComposableArchitecture.Reducer {
		@Dependency(\.networkConnectivityService) var networkConnectivityService
		@Dependency(\.networkConnectivityRefreshService) var networkConnectivityRefreshService

		public init () { }

		public var body: some ComposableArchitecture.Reducer<State, Action> {
			Reduce { state, action in
				switch action {
				case .initialize: return initialize(&state)
				case .refresh: return refresh(&state)
				case .refreshCompleted: refreshCompleted(&state)
				case .onConnectionStateChanged(let connectionState): onConnectionStateChanged(connectionState, &state)
				}

				return .none
			}
		}
	}
}

// MARK: - Action handlers
private extension ConnectionStateFeature.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		subscribeOnConnectionState()
	}

	func refresh (_ state: inout State) -> Effect<Action> {
		state.isRefreshing = true

		return .run { send in
			try? await networkConnectivityRefreshService.refresh()
			await send(.refreshCompleted)
		}
	}

	func refreshCompleted (_ state: inout State) {
		state.isRefreshing = false
	}

	func onConnectionStateChanged (_ connectionState: ConnectionState, _ state: inout State) {
		state.connectionState = connectionState
	}
}

// MARK: - Functions
private extension ConnectionStateFeature.Reducer {
	func subscribeOnConnectionState () -> Effect<Action> {
		.publisher {
			networkConnectivityService.state.map(Action.onConnectionStateChanged)
		}
	}
}
