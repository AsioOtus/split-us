import ComposableArchitecture
import NetworkUtil
import DLServices
import DLUtils

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
		
		public let configurations: [URLRequestConfiguration] = [
			.testVm,
			.dev149,
			.dev150,
			.dev151,
			.phone,
			.localhost,
		]
		
		var selectedConfiguration: URLRequestConfiguration = {
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
