import AmountComponents
import ComposableArchitecture
import DLServices
import Foundation
import DLModels
import UserComponents
import DLUtils

extension TransferEditing {
	@CasePathable
	public enum Action: BindableAction {
		case binding(BindingAction<State>)

		case initialize
		case refresh

		case onSubmitButtonTap
		case onCancelButtonTap

		case onCreationCompleted(Loadable<TransferUnit>)
		case onUpdatingCompleted(Loadable<TransferUnit>)

		case onUsersResponse(Loadable<[User.Compact]>)

		case creditorSelectedMenu(UserSelectionMenu.Reducer.Action)
	}
}
