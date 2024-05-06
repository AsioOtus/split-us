import ComposableArchitecture
import DLModels
import SwiftUI
import ILModels

extension Transfers {
	struct TransferRowView: View {
		let store: StoreOf<Transfers.Reducer>

		let currencyFormatter = NumberFormatter.currency
		let userInfoModelMapper = UserInfoModel.Mapper.default

		let transfer: Transfer
		let superTransferGroup: TransferGroup?

		var body: some View {
			Transfers.TransferInfoView(
				transferInfo: .init(
					transferUnitInfo: transfer.info,
					amounts: [currencyFormatter.format(transfer.amount)],
					creditors: transfer.creditor.map(userInfoModelMapper.map).map { [$0] } ?? [],
					borrowers: transfer.borrower.map(userInfoModelMapper.map).map { [$0] } ?? []
				)
			)
			.swipeActions(edge: .leading, allowsFullSwipe: false) {
				deleteTransferButton(transfer.id)
			}
			.swipeActions {
				editTransferButton(transfer, superTransferGroup)
			}
			.contextMenu(menuItems: contextMenuView)
		}
	}
}

private extension Transfers.TransferRowView {
	@ViewBuilder
	func contextMenuView () -> some View {
		editTransferButton(transfer, superTransferGroup)
		Divider()
		deleteTransferButton(transfer.id)
	}
}

private extension Transfers.TransferRowView {
	func deleteTransferButton (_ transferId: UUID) -> some View {
		Button(role: .destructive) {
			store.send(.deleteTransfer(transferId: transferId))
		} label: {
			Label(.generalActionDelete, systemImage: "trash")
		}
		.tint(.red)
	}

	func editTransferButton (_ transfer: Transfer, _ superTransferGroup: TransferGroup?) -> some View {
		Button {
			store.send(.editTransfer(initial: transfer, superTransferGroup: superTransferGroup))
		} label: {
			Label(.generalActionEdit, systemImage: "square.and.pencil")
		}
		.tint(.blue)
	}
}
