import ComposableArchitecture
import ScreenTransferEditing
import ScreenTransferGroupEditing
import DLServices
import DLModels
import TransferComponents
import DLUtils

extension TransferList {
	@ObservableState
	public struct State: Equatable {
		let userGroup: UserGroup
		
		var transfers: Loadable<Transfers.State> = .initial()

		@Presents var transferEditing: TransferEditing.Reducer.State?
		@Presents var transferGroupEditing: TransferGroupEditing.Reducer.State?

		public init (userGroup: UserGroup) {
			self.userGroup = userGroup
		}
	}
}

extension TransferList {
	@CasePathable
	public enum Action {
		case initialize
		case refresh
		
		case onTransfersLoaded(Loadable<[TransferUnit]>)
		
		case onTransferCreateButtonTap
		case onTransferGroupCreateButtonTap
		
		case transfers(Transfers.Action)
		
		case transferGroupEditing(PresentationAction<TransferGroupEditing.Action>)
		case transferEditing(PresentationAction<TransferEditing.Action>)
	}
}
