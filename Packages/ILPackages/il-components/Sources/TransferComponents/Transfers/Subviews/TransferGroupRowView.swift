import ComposableArchitecture
import DLModels
import SwiftUI
import ILModels
import ILModelsMappers
import UserComponents

extension Transfers {
	struct TransferGroupRowView: View {
		@Environment(\.userRelationshipState) private var userRelationshipState
		
		@SwiftUI.State private var isExpanded = false
		
		let store: StoreOf<Transfers.Reducer>
		let currencyFormatter = NumberFormatter.currency
		let userInfoModelMapper = UserInfoModel.Mapper.default
		
		let transferGroupContainer: TransferGroup.Container
		let superTransferGroup: TransferGroup?
		
		var body: some View {
			DisclosureGroup(
				isExpanded: $isExpanded,
				content: {
					ForEach(transferGroupContainer.transferUnits, id: \.self) {
						TransferUnitRowView(
							store: store,
							transferUnit: $0,
							superTransferGroup: transferGroupContainer.transferGroup
						)
						.userRelationshipState(transferGroupContainer.transferUnits.isSingleCreditor ? .hiddenCreditors : userRelationshipState)
					}
				},
				label: {
					Transfers.TransferInfoView(
						transferInfo: .init(
							transferUnitInfo: transferGroupContainer.transferGroup.info,
							amounts: transferGroupContainer.transferUnits.amountsSum.map(currencyFormatter.format),
							creditors: transferGroupContainer.transferUnits.uniqueCreditors.map(userInfoModelMapper.map),
							borrowers: transferGroupContainer.transferUnits.uniqueBorrowers.map(userInfoModelMapper.map)
						)
					)
					.userRelationshipState(transferGroupContainer.transferUnits.isSingleCreditor && isExpanded ? .hiddenBorrowers : userRelationshipState)
					.swipeActions(edge: .leading, allowsFullSwipe: false) {
						deleteButton(transferGroupContainer.transferGroup.id)
					}
					.swipeActions {
						addTransferButton(transferGroupContainer.transferGroup)
						addTransferGroupButton(transferGroupContainer.transferGroup)
						editTransferGroupButton(transferGroupContainer, superTransferGroup)
					}
					.contextMenu(menuItems: contextMenuView)
				}
			)
		}
	}
}

private extension Transfers.TransferGroupRowView {
	@ViewBuilder
	func contextMenuView () -> some View {
		addTransferButton(transferGroupContainer.transferGroup)
		addTransferGroupButton(transferGroupContainer.transferGroup)
		Divider()
		editTransferGroupButton(transferGroupContainer, superTransferGroup)
		Divider()
		deleteButton(transferGroupContainer.transferGroup.id)
	}
}

private extension Transfers.TransferGroupRowView {
	func deleteButton (_ transferGroupId: UUID) -> some View {
		Button(role: .destructive) {
			store.send(.deleteTransferGroup(transferGroupId: transferGroupId))
		} label: {
			Label(.generalActionDelete, systemImage: "trash")
		}
		.tint(.red)
	}
	
	func addTransferButton (_ transferGroup: TransferGroup) -> some View {
		Button {
			store.send(.addTransfer(superTransferGroup: transferGroup))
		} label: {
			Label(.transferGroupAddTransfer, systemImage: "plus.rectangle")
		}
		.tint(.green)
		
	}
	
	func addTransferGroupButton (_ transferGroup: TransferGroup) -> some View {
		Button {
			store.send(.addTransferGroup(superTransferGroup: transferGroup))
		} label: {
			Label(.transferGroupAddTransferGroup, systemImage: "plus.rectangle.on.rectangle")
		}
		.tint(.green)
	}
	
	func editTransferGroupButton (_ transferGroupContainer: TransferGroup.Container, _ superTransferGroup: TransferGroup?) -> some View {
		Button {
			store.send(.editTransferGroup(initial: transferGroupContainer, superTransferGroup: superTransferGroup))
		} label: {
			Label(.generalActionEdit, systemImage: "square.and.pencil")
		}
		.tint(.blue)
	}
}
