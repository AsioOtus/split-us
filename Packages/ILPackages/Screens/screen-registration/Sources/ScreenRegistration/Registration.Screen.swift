import ButtonComponents
import ComposableArchitecture
import HintListComponent
import SwiftUI
import UnavailablePlaceholderComponents
import ILComponentsViewModifiers

extension Registration {
	public struct Screen: View {
		@FocusState private var isPasswordFieldFocused: Bool
		
		@Bindable var store: StoreOf<Reducer>
		
		public init (store: StoreOf<Reducer>) {
			self.store = store
		}
		
		public var body: some View {
			NavigationStack {
				Form {
					Group {
						emailView()
						usernameView()
						passwordsView()
						
						displayNameView()
					}
					.disabled(store.registrationRequest.isLoading)
					
					registerButton()
				}
				.animation(.default, value: store.state)
				.textInputAutocapitalization(.never)
				.disableAutocorrection(true)
				.navigationTitle(.generalRegistration)
				.toolbar {
					ToolbarItem(placement: .topBarLeading) {
						cancelButton()
					}
				}
				.sensoryFeedback(.error, trigger: store.submitErrorTrigger)
			}
			.onAppear {
				store.send(.initialize)
			}
		}
	}
}

private extension Registration.Screen {
	@MainActor
	func emailView () -> some View {
		Section {
			TextField(.generalEmail, text: $store.email) { editingChanged in
				if !editingChanged {
					store.send(.onEmailFieldFocusLost)
				}
			}
			.keyboardType(.emailAddress)
		} header: {
			Text(.registrationRequiredFields)
		} footer: {
			if store.validation.shouldShowEmailMismatch {
				errorMessageView(.registrationEmailWarningIncorrect)
			}
		}
	}
	
	@MainActor
	func usernameView () -> some View {
		Section {
			TextField(.generalUsername, text: $store.username) { editingChanged in
				if editingChanged {
					store.send(.onUsernameFieldFocusSet)
				} else {
					store.send(.onUsernameFieldFocusLost)
				}
			}
			.usernameField()
			
			if store.isUsernameHintRequired {
				HintList(state: store.state.usernameHintsState)
					.padding(.leading, 8)
			}
		} footer: {
			VStack(alignment: .leading) {
				if store.validation.shouldShowUsernameMismatch {
					errorMessageView(.registrationUsernameWarningIncorrect)
				}
				
				Text(.registrationUsernameDescription)
			}
		}
	}
	
	@MainActor
	func passwordsView () -> some View {
		Section {
			SecureField(.generalPassword, text: $store.password.animation())
				.focused($isPasswordFieldFocused)
				.onChange(of: isPasswordFieldFocused) {
					if isPasswordFieldFocused {
						store.send(.onPasswordFocusSet)
					} else {
						store.send(.onPasswordFocusLost)
					}
				}
			
			if store.isPasswordHintRequired {
				HintList(state: store.state.passwordHintsState)
					.padding(.leading, 8)
			}
			
			SecureField(.registrationRepeatPassword, text: $store.passwordRepeat.animation())
		} footer: {
			if store.validation.shouldShowPasswordMismatch {
				errorMessageView(.registrationPasswordWarningIncorrect)
			} else if store.shouldShowPasswordsMismatch {
				errorMessageView(.registrationPasswordWarningEquality)
			}
		}
	}
	
	@MainActor
	func displayNameView () -> some View {
		Section {
			TextField(.registrationDisplayName, text: $store.name)
		} header: {
			Text(.registrationOptionalFields)
		} footer: {
			Text(.registrationDisplayNameDescription)
		}
	}
	
	func registerButton () -> some View {
		Section {
			HStack {
				LoadableButton(label: .generalActionSignUp, loadable: store.registrationRequest) {
					store.send(.onSignUpButtonTap)
				}
			}
			.frame(maxWidth: .infinity, alignment: .center)
		} footer: {
			if store.registrationRequest.isFailed {
				requestErrorView()
			}
		}
	}
	
	func cancelButton () -> some View {
		Button(.generalActionCancel, role: .destructive) {
			store.send(.onLogInButtonTap)
		}
	}
	
	func requestErrorView () -> some View {
		errorMessageView(.registrationRequestFailed)
	}
}

private extension Registration.Screen {
	func errorMessageView (_ text: LocalizedStringKey) -> some View {
		InlineErrorMessageView(message: text)
	}
}
