import ComposableArchitecture
import DLModels
import DLUtils

extension Registration {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = Registration.State
		public typealias Action = Registration.Action
		
		@Dependency(\.analyticsService) var analyticsService
		@Dependency(\.authorizationService) var authorizationService
		@Dependency(\.emailValidationService) var emailValidationService
		@Dependency(\.usernameValidationService) var usernameValidationService
		@Dependency(\.passwordValidationService) var passwordValidationService
		
		public init () { }
		
		public var body: some ComposableArchitecture.Reducer<State, Action> {
			BindingReducer()
			
			Reduce { state, action in
				switch action {
				case .binding(\.email):
					onEmailChanged(&state)
					
				case .binding(\.username):
					onUsernameChanged(&state)
					
				case .binding(\.password):
					onPasswordChanged(&state)
					
				case .binding(\.passwordRepeat):
					onPasswordRepeatChanged(&state)
					
				case .initialize:
					initialize(&state)
					
				case .onEmailFieldFocusLost:
					onEmailFieldFocusLost(&state)
					
				case .onUsernameFieldFocusSet:
					onUsernameFieldFocusSet(&state)
					
				case .onUsernameFieldFocusLost:
					onUsernameFieldFocusLost(&state)
					
				case .onPasswordFocusSet:
					onPasswordFocusSet(&state)
					
				case .onPasswordFocusLost:
					onPasswordFocusLost(&state)
					
				case .onSignUpButtonTap:
					return onSignUpButtonTap(&state)
					
				case .onRegistrationLoaded(.success):
					onRegistrationSuccess()
					
				case .onRegistrationLoaded(.failure(let error)):
					onRegistrationFailure(error, &state)
					
				default: break
				}
				
				return .none
			}
		}
	}
}

private extension Registration.Reducer {
	func initialize (_ state: inout State) {
		validateAll(&state)
	}
	
	func onEmailChanged (_ state: inout State) {
		state.validation.emailMismatches = emailValidationService.validate(state.email)
	}
	
	func onUsernameChanged (_ state: inout State) {
		state.validation.usernameMismatches = usernameValidationService.validate(state.username)
		state.validation.isUsernameResultRequired = !state
			.validation
			.usernameMismatches
			.intersection([.tooLong, .containsProhibitedSymbols])
			.isEmpty
	}
	
	func onPasswordChanged (_ state: inout State) {
		state.validation.passwordMismatches = passwordValidationService.validate(state.password)
		print(state.validation.passwordMismatches.rawValue.bigEndian.data.bin)
	}
	
	func onPasswordRepeatChanged (_ state: inout State) {
		
	}
	
	func onEmailFieldFocusLost (_ state: inout State) {
		state.validation.isEmailResultRequired = true
	}
	
	func onUsernameFieldFocusSet (_ state: inout State) {
		state.isUsernameHintRequired = true
	}
	
	func onUsernameFieldFocusLost (_ state: inout State) {
		state.validation.isUsernameResultRequired = true
	}
	
	func onPasswordFocusSet (_ state: inout State) {
		state.isPasswordHintRequired = true
	}
	
	func onPasswordFocusLost (_ state: inout State) {
		state.validation.isPasswordResultRequired = true
	}
	
	func onSignUpButtonTap (_ state: inout State) -> Effect<Action> {
		if state.validation.isValid && state.isPasswordsEqual {
			setAllHintsRequirement(isRequired: false, &state)
			return register(&state)
		} else {
			state.submitErrorTrigger *= -1
			
			state.validation.isStrictValidationMode = true
			setAllValidationResultsRequirement(isRequired: true, &state)
			
			return .none
		}
	}
	
	func onRegistrationSuccess () {
		analyticsService.log(.registrationCompleted)
	}
	
	func onRegistrationFailure (_ error: Error, _ state: inout State) {
		state.registrationRequest = .failed(error)
	}
}

private extension Registration.Reducer {
	func register (_ state: inout State) -> Effect<Action> {
		state.registrationRequest.setLoading()
		
		return .run { [state] send in
			let authCredentials = await Result {
				try await authorizationService
					.register(
						user: .init(
							name: state.name,
							email: state.email,
							username: state.username,
							password: state.password
						)
					)
			}
			
			await send(.onRegistrationLoaded(authCredentials))
		}
	}
	
	func validateAll (_ state: inout State) {
		state.validation.emailMismatches = emailValidationService.validate(state.email)
		state.validation.usernameMismatches = usernameValidationService.validate(state.username)
		state.validation.passwordMismatches = passwordValidationService.validate(state.password)
	}
	
	func setAllHintsRequirement (isRequired: Bool, _ state: inout State) {
		state.isUsernameHintRequired = isRequired
		state.isPasswordHintRequired = isRequired
	}
	
	func setAllValidationResultsRequirement (isRequired: Bool, _ state: inout State) {
		state.validation.isEmailResultRequired = true
		state.validation.isUsernameResultRequired = true
		state.validation.isPasswordResultRequired = true
		
		state.validation.isPasswordEqualityCheckRequired = true
	}
}
