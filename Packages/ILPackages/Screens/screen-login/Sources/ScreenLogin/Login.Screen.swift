import ComposableArchitecture
import ILComponents
import ILDebug
import ILLocalization
import SwiftUI

extension Login {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			NavigationStack {
				Form {
					Section {
						loginField()
						passwordField()
						loginButton()
					}

					Section {
						registrationButton()
					}

					Section {
						Debug.Configuration.Screen(
							store: store.scope(state: \.debugConfiguration, action: \.debugConfiguration)
						)
					} header: {
						Text("Debug info")
					}
				}
				.disabled(store.loginRequest.isLoading)
				.navigationTitle(.generalLogIn)
			}
			.task {
				store.send(.initialize)
			}
		}
	}
}

private extension Login.Screen {
	func loginField () -> some View {
		TextField(.generalUsername, text: $store.username)
			.textInputAutocapitalization(.never)
			.disableAutocorrection(true)
	}

	func passwordField () -> some View {
		SecureField(.generalPassword, text: $store.password)
			.onSubmit {
				store.send(.onLoginButtonPressed)
			}
			.submitLabel(.done)
	}

	func loginButton () -> some View {
		HStack {
			LoadableButton(label: .generalActionSignIn, loadable: store.loginRequest) {
				store.send(.onLoginButtonPressed)
			}
		}
		.frame(maxWidth: .infinity, alignment: .center)
	}

	func registrationButton () -> some View {
		HStack {
			Button(.generalRegistration) {
				store.send(.onRegistrationButtonTap)
			}
		}
		.frame(maxWidth: .infinity, alignment: .center)
	}
}
