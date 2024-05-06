import ComposableArchitecture
import Foundation
import ScreenTransferEditing
import DLModels
import TransferComponents

extension TransferGroupEditing {
	public struct TransfersReducer: ComposableArchitecture.Reducer {
		public typealias Action = Transfers.Action
		public typealias State = TransferGroupEditing.State

		@Dependency(\.transferService) var transferService

		public func reduce (into state: inout State, action: Action) -> Effect<Action> {
			switch action {
			case .addTransfer(superTransferGroup: let superTransferGroup):
				addTransfer(
					superTransferGroup,
					&state
				)

			case .addTransferGroup(let superTransferGroup):
				addTransferGroup(
					superTransferGroup,
					&state
				)

			case .editTransfer(initial: let initial, superTransferGroup: let superTransferGroup):
				editTransfer(
					initial,
					superTransferGroup,
					&state
				)

			case .editTransferGroup(let initialTransferGroupContainer, let superTransferGroup):
				editTransferGroup(
					initialTransferGroupContainer,
					superTransferGroup,
					&state
				)

			case .deleteTransfer(let transferId):
				return deleteTransfer(transferId, &state)
			case .deleteTransferGroup(let transferGroupId):
				return deleteTransferGroup(transferGroupId, &state)
			}

			return .none
		}
	}
}

private extension TransferGroupEditing.TransfersReducer {
	func addTransfer (
		_ superTransferGroup: TransferGroup?,
		_ state: inout State
	) {
		let initialCreditor = state.sharedInfo.isEnabled ? state.sharedInfo.creditor : nil

		state.transferEditing = .creation(
			isLocal: state.isLocal || state.isCreation,
			superTransferGroupId: superTransferGroup?.id,
			userGroup: state.userGroup,
			initialCreditor: initialCreditor,
			remainingAmountValue: state.sharedInfo.remainingAmountValue
		)
	}

	func addTransferGroup (
		_ superTransferGroup: TransferGroup?,
		_ state: inout State
	) {
		state.transferGroupEditing = .creation(
			isLocal: state.isLocal || state.isCreation,
			superTransferGroupId: superTransferGroup?.id,
			userGroup: state.userGroup,
			sharedInfo: state.sharedInfo
		)
	}

	func editTransfer (
		_ initialTransfer: Transfer,
		_ superTransferGroup: TransferGroup?,
		_ state: inout State
	) {
		state.transferEditing = .updating(
			initialTransferUnit: .init(transfer: initialTransfer),
			superTransferGroupId: superTransferGroup?.id,
			userGroup: state.userGroup
		)
	}

	func editTransferGroup (
		_ initialTransferGroupContainer: TransferGroup.Container,
		_ superTransferGroup: TransferGroup?,
		_ state: inout State
	) {
		state.transferGroupEditing = .updating(
			initialTransferGroupContainer: initialTransferGroupContainer,
			isLocal: state.isLocal || state.isCreation,
			superTransferGroupId: superTransferGroup?.id,
			userGroup: state.userGroup
		)
	}

	func deleteTransfer (
		_ transferId: UUID,
		_ state: inout State
	) -> Effect<Action> {
		.run { _ in
			try await transferService.deleteTransfer(id: transferId)
		}
	}

	func deleteTransferGroup (
		_ transferGroupId: UUID,
		_ state: inout State
	) -> Effect<Action> {
		.run { _ in
			try await transferService.deleteTransferGroup(id: transferGroupId)
		}
	}
}
