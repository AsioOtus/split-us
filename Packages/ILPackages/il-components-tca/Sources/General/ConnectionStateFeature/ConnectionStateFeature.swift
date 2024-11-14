import ComposableArchitecture
import DLModels
import DLServices

// MARK: - Feature
public enum ConnectionStateFeature { }

// MARK: - State
extension ConnectionStateFeature {
	@ObservableState
	public struct State: Equatable {
		public var connectionState: ConnectionState = .online
		public var isRefreshing: Bool = false

		public init () { }
	}
}

// MARK: - Action
extension ConnectionStateFeature {
	public enum Action {
		case initialize
		
		case refresh
		case refreshCompleted

		case onConnectionStateChanged(ConnectionState)
	}
}
