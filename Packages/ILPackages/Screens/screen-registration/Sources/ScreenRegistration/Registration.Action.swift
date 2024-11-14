import ComposableArchitecture
import DLServices
import DLModels

public enum Registration { }

extension Registration {
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		
		case initialize
		
		case onEmailFieldFocusLost
		case onUsernameFieldFocusSet
		case onUsernameFieldFocusLost
		case onPasswordFocusSet
		case onPasswordFocusLost
		
		case onSignUpButtonTap
		case onRegistrationLoaded(Result<(tokens: TokenPair, user: User), Error>)
		
		case onLogInButtonTap
	}
}
