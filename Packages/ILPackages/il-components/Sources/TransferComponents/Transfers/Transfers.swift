import ComposableArchitecture
import Foundation
import DLModels
import DLUtils

// MARK: - Feature
public enum Transfers { }

// MARK: - State
extension Transfers {
	@ObservableState
	public struct State: Equatable {
		public let userGroup: UserGroup
		public let superTransferGroup: TransferGroup?
		public let transferUnits: [TransferUnit]

		public init (
			userGroup: UserGroup,
			superTransferGroup: TransferGroup?,
			transferUnits: [TransferUnit]
		) {
			self.userGroup = userGroup
			self.superTransferGroup = superTransferGroup
			self.transferUnits = transferUnits
		}
	}
}

// MARK: - Action
extension Transfers {
	@CasePathable
	public enum Action {
		case addTransferGroup(superTransferGroup: TransferGroup)
		case editTransferGroup(initial: TransferGroup.Container, superTransferGroup: TransferGroup?)

		case addTransfer(superTransferGroup: TransferGroup)
		case editTransfer(initial: Transfer, superTransferGroup: TransferGroup?)

		case deleteTransfer(transferId: UUID)
		case deleteTransferGroup(transferGroupId: UUID)
	}
}
