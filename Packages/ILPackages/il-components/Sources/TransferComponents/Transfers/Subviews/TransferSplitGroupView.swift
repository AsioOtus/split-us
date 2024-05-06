import DLModels
import SwiftUI
import ILModels
import ILModelsMappers

extension Transfers {
	struct TransferSplitGroupView: View {
		let transferSplitGroup: TransferSplitGroup

		let currencyFormatter = NumberFormatter.currency
		let userInfoModelMapper = UserInfoModel.Mapper.default

		var body: some View {
			DisclosureGroup(
				content: contentView,
				label: labelView
			)
		}
	}
}

private extension Transfers.TransferSplitGroupView {
	func labelView () -> some View {
		Transfers.TransferInfoView(
			transferInfo: .init(
				transferUnitInfo: transferSplitGroup.info,
				amounts: [currencyFormatter.format(transferSplitGroup.amount)],
				creditors: transferSplitGroup.creditor.map(userInfoModelMapper.map).map { [$0] } ?? [],
				borrowers: Array(transferSplitGroup.borrowerAmounts.keys.map(userInfoModelMapper.map))
			)
		)
	}

	func contentView () -> some View {
		Text("Content")
	}
}
