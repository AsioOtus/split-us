import ComposableArchitecture
import DLServices
import ILDebug
import ILDebugTCA
import ILLocalization

extension Settings {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = Settings.State
		public typealias Action = Settings.Action

		@Dependency(\.currentUserService) var currentUserService
		@Dependency(\.localPersistenceService) var localPersistenceService
		@Dependency(\.logoutEventChannel) var logoutEventChannel

		public init () { }

		public var body: some ReducerOf<Self> {
			Reduce { state, action in
				switch action {
				case .initialize: initialize(&state)
				case .onClearPersistentDataButtonTap: onClearPersistentDataButtonTap(&state)
				case .logout: return logout()

				case .clearPersistentDataDialog(.presented(.onConfirmation)): onClearPersistentDataConfirmation()
					
				default: break
				}

				return .none
			}
			.ifLet(\.$clearPersistentDataDialog, action: \.clearPersistentDataDialog)

			Scope(state: \.debugConfiguration, action: \.debugConfiguration) {
				Debug.Configuration.Reducer()
			}
		}
	}
}

private extension Settings.Reducer {
	func initialize (_ state: inout State) {
		if let user = currentUserService.user.value {
			state.user = .successful(user)
		}
	}

	func onClearPersistentDataButtonTap (_ state: inout State) {
		state.clearPersistentDataDialog = ConfirmationDialogState {
			TextState(.settingsClearSavedDataConfirmationDialogTitle)
		} actions: {
			ButtonState(role: .cancel) {
				TextState(.generalActionCancel)
			}

			ButtonState(role: .destructive, action: .onConfirmation) {
				TextState(.settingsClearSavedDataConfirmationDialogConfirmationTitle)
			}
		} message: {
			TextState(.settingsClearSavedDataConfirmationDialogDescription)
		}
	}

	func onClearPersistentDataConfirmation () {
		localPersistenceService.clear()
	}

	func logout () -> Effect<Action> {
		.run { _ in
			await logoutEventChannel.send(.logout(.userAction))
		}
	}
}
