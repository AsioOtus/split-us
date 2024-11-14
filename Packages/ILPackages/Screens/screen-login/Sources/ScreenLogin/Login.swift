import ComposableArchitecture
import ILDebug
import DLModels
import Foundation
import ILDebugTCA
import ILUtilsTCA
import Multitool

public enum Login { }

extension Login {
	@ObservableState
	public struct State: Equatable {
		public var username: String
		public var password: String
		
		public var loginRequest = Loadable<Never>.initial
		
		var debugConfiguration: Debug.Configuration.State = .init()
		
		public init (
			username: String,
			password: String
		) {
			self.username = username
			self.password = password
		}
		
		public init () {
			self.username = Debug.value { UserDefaults.standard.string(forKey: "login-username") ?? "" }
			self.password = Debug.value { UserDefaults.standard.string(forKey: "login-password") ?? "" }
		}
	}
}

extension Login {
	@CasePathable
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		
		case initialize
		
		case onRegistrationButtonTap
		
		case onLoginButtonPressed
		case onLoginRequestLoaded(Loadable<(tokens: TokenPair, user: User)>)
		
		case debugConfiguration(Debug.Configuration.Action)
	}
}
