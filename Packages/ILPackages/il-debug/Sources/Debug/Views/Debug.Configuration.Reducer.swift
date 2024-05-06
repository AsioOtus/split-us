import ComposableArchitecture
import Foundation
import ILFormatters
import NetworkUtil
import DLServices
import ILExtensions

// MARK: - Body
extension Debug.Configuration {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = Debug.Configuration.State
		public typealias Action = Debug.Configuration.Action
		
		@Dependency(\.requestsConfiguration) var requestsConfiguration
		
		let appVersionFormatter = AppVersionFormatter.default
		
		public init () { }
		
		public var body: some ComposableArchitecture.Reducer<State, Action> {
			BindingReducer()
			
			Reduce { state, action in
				switch action {
				case .binding(\.selectedConfiguration): onConfigurationSelected(&state)
				case .binding(\.subpath): onBindingSubpath(&state)
				case .binding: break
					
				case .initialize: initialize(&state)
				}
				
				return .none
			}
		}
	}
}

// MARK: - Action handlers
private extension Debug.Configuration.Reducer {
	func initialize (_ state: inout State) {
		state.appVersion = appVersion()
		state.subpath = requestsConfiguration.value.baseSubpath ?? ""
	}
	
	func onConfigurationSelected (_ state: inout State) {
		requestsConfiguration.value = state.selectedConfiguration
	}
	
	func onBindingSubpath (_ state: inout State) {
		requestsConfiguration.value = requestsConfiguration.value.setBaseSubpath(state.subpath)
	}
}

// MARK: - Functions
private extension Debug.Configuration.Reducer {
	func appVersion () -> String {
		appVersionFormatter.format(
			version: Bundle.main.appVersion(),
			buildNumber: Bundle.main.buildNumber()
		) ?? "<unknown version>"
	}
}
