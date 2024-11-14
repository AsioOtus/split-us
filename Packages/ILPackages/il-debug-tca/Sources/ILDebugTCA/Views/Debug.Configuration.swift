import ComposableArchitecture
import ILDebug
import DLServices
import NetworkUtil

// MARK: - Feature
extension Debug {
	public enum Configuration { }
}

// MARK: - State
extension Debug.Configuration {
	@ObservableState
	public struct State: Equatable {
		var appVersion = ""
		var subpath = ""
		var isOfflineMode = false

		public let configurations: [RequestConfiguration] = [
			.testVm,
			.dev149,
			.dev150,
			.dev151,
			.phone,
			.localhost,
		]
		
		var selectedConfiguration: RequestConfiguration = {
			@Dependency(\.requestsConfiguration) var requestsConfiguration
			return requestsConfiguration.value
		}()
		
		public init () { }
	}
}

// MARK: - Action
extension Debug.Configuration {
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		
		case initialize
	}
}
