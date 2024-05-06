import ComposableArchitecture
import DLModels
import SwiftUI

struct TransferUnitRowView: View {
	let store: StoreOf<Transfers.Reducer>
	
	let transferUnit: TransferUnit
	let superTransferGroup: TransferGroup?

	var body: some View {
		switch transferUnit.value {
		case .transfer(let transfer):
			Transfers.TransferRowView(
				store: store,
				transfer: transfer,
				superTransferGroup: superTransferGroup
			)
			
		case .transferGroup(let transferGroup):
			Transfers.TransferGroupRowView(
				store: store,
				transferGroupContainer: .init(
					transferGroup: transferGroup,
					transferUnits: transferUnit.nodes
				),
				superTransferGroup: superTransferGroup
			)

		case .transferSplitGroup(let transferSplitGroup):
			Transfers.TransferSplitGroupView(
				transferSplitGroup: transferSplitGroup
			)
		}
	}
}
