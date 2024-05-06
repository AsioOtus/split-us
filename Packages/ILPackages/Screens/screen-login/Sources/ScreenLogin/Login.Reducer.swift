import ComposableArchitecture
import Debug
import DLServices
import DLModels
import DLUtils

extension Login {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = Login.State
		public typealias Action = Login.Action
		
		@Dependency(\.analyticsService) var analyticsService
		@Dependency(\.authorizationService) var authorizationService
		@Dependency(\.requestsConfiguration) var requestsConfiguration
		
		public init () { }
		
		public var body: some ComposableArchitecture.Reducer<State, Action>  {
			BindingReducer()
			
			Reduce { state, action in
				switch action {
				case .initialize: initialize(&state)
					
				case .onLoginButtonPressed: return onLoginButtonPressed(&state)
				case .onLoginRequestLoaded(.successful((_, let user))): onLoginRequestSuccessful(user)
				case .onLoginRequestLoaded(.failed(let error)): onLoginFailed(error: error, &state)
					
				default:
					break
				}
				
				return .none
			}
			
			Scope(state: \.debugConfiguration, action: /Action.debugConfiguration) {
				Debug.Configuration.Reducer()
			}
		}
	}
}

private extension Login.Reducer {
	func initialize (_ state: inout State) { }
	
	func onLoginButtonPressed (_ state: inout State) -> Effect<Action> {
		login(&state)
	}
	
	func onLoginRequestSuccessful (_ user: User) {
		analyticsService.log(.login(mode: .initial, username: user.username))
	}
	
	func onLoginFailed (error: Error, _ state: inout State) {
		state.loginRequest = .failed(error)
	}
}

private extension Login.Reducer {
	func login (_ state: inout State) -> Effect<Action> {
		state.loginRequest.setLoading()
		
		return .run { [state] send in
			let authCredentials = await Loadable.result {
				try await authorizationService.authenticate(username: state.username, password: state.password)
			}
			await send(.onLoginRequestLoaded(authCredentials))
		}
	}
}
