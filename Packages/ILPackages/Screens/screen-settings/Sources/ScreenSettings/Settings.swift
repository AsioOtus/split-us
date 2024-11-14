import ComposableArchitecture
import ILDebug
import ILDebugTCA
import DLModels
import Multitool

public enum Settings { }

extension Settings {
	@ObservableState
	public struct State: Equatable {
		public var user: Loadable<User> = .initial

		@Presents var clearPersistentDataDialog: ConfirmationDialogState<Action.ClearPersistentDateDialog>?

		var debugConfiguration: Debug.Configuration.State = .init()

		public init () { }
	}
}

extension Settings {
	@CasePathable
	public enum Action {
		case initialize
		case onClearPersistentDataButtonTap
		case logout

		case clearPersistentDataDialog(PresentationAction<ClearPersistentDateDialog>)

		case debugConfiguration(Debug.Configuration.Action)

		@CasePathable
		public enum ClearPersistentDateDialog {
			case onConfirmation
		}
	}
}
