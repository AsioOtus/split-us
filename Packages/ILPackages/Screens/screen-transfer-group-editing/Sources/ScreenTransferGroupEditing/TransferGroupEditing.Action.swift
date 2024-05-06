import ComposableArchitecture
import Foundation
import ScreenTransferEditing
import DLServices
import DLModels
import TransferComponents
import DLUtils

extension TransferGroupEditing {
	@CasePathable
	public indirect enum Action: BindableAction {
		case binding(BindingAction<State>)

		case initialize
		case refresh

		case toggleSharedInfo

		case onRefreshCompleted(Result<TransferUnit, Error>)
		case onUsersResponse(Loadable<[User.Compact]>)

		case onSubmitButtonTap
		case onCreationCompleted(Loadable<(TransferGroup.Container)>)
		case onUpdatingCompleted(Loadable<(TransferGroup.Container)>)

		case onCancelButtonTap

		case onTransferGroupCreateButtonTap
		case onTransferCreateButtonTap

		case transfers(Transfers.Action)

		case transferGroupEditing(PresentationAction<Self>)
		case transferEditing(PresentationAction<TransferEditing.Action>)
	}
}
