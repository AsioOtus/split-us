import ComposableArchitecture
import DLModels
import Multitool
import ScreenLogin
import ScreenRegistration

enum Root { }

extension Root {
	@ObservableState
	@CasePathable
	@dynamicMemberLookup
	enum State {
		case splash
		case main(Main.Reducer.State)
		case login(Login.State)
		case registration(Registration.State)

		var isSplash: Bool { if case .splash = self { true } else { false } }
		var isMain:   Bool { if case .main   = self { true } else { false } }
	}
}

extension Root {
	@CasePathable
	enum Action {
		case initialize

		case onUserLoadingSuccess(User)
		case onUserLoadingFailure(Error)
		case onLogout

		case splash
		case main(Main.Reducer.Action)
		case login(Login.Action)
		case registration(Registration.Action)
	}
}
