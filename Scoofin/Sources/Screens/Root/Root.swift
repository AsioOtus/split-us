import ComposableArchitecture
import DLModels
import DLUtils
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
	}
}

extension Root {
	@CasePathable
	enum Action {
		case initialize

		case onUserLoaded(Loadable<User>)
		case onLogout

		case splash
		case main(Main.Reducer.Action)
		case login(Login.Action)
		case registration(Registration.Action)
	}
}
