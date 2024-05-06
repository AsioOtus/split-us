import AmountComponents
import ILModels
import SwiftUI
import UserComponents

extension Transfers {
	struct TransferInfoView: View {
		let transferInfo: TransferInfoModel

		var body: some View {
			HStack(alignment: .center) {
				VStack(alignment: .leading) {
					if let name = transferInfo.transferUnitInfo.name {
						nameView(name)
					}
					amountsView()
				}

				Spacer()

				usersRelationshipView()
			}
		}
	}
}

private extension Transfers.TransferInfoView {
	func nameView (_ name: String) -> some View {
		Text(name)
			.font(.caption)
	}

	func amountsView () -> some View{
		AmountStack(amounts: transferInfo.amounts) { amount in
			AmountView(amount)
		}
	}

	func usersRelationshipView () -> some View {
		UsersRelationshipView(
			creditors: transferInfo.creditors,
			borrowers: transferInfo.borrowers
		)
		.padding(.trailing, 16)
	}
}
