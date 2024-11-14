import ILComponents
import ILModels
import SwiftUI

struct ExpenseParticipantsView: View {
	static let creditorAmountAnimationId = "ExpenseParticipantsView-creditorAmountAnimationId"

	let creditor: ExpenseParticipantScreenModel?
	let borrowers: [ExpenseParticipantScreenModel]
	let undistributedAmount: AmountScreenModel?

	let animationNamespace: Namespace.ID

	var indexedBorrowers: [(Int, ExpenseParticipantScreenModel)] {
		Array(zip(borrowers.indices, borrowers))
	}

	var body: some View {
		Grid(horizontalSpacing: 16, verticalSpacing: 4) {
			if let creditor {
				creditorSection(creditor)
					.padding(.bottom, 8)
			}

			if let undistributedAmount {
				undistributedAmountSection(undistributedAmount)
					.padding(.bottom, 8)
			}

			borrowersSection()
		}
	}
}

private extension ExpenseParticipantsView {
	@ViewBuilder
	func creditorSection (_ creditor: ExpenseParticipantScreenModel) -> some View {
		GridRow {
			AmountView(creditor.amount)
				.gridCellAnchor(.trailing)
				.matchedGeometryEffect(id: Self.creditorAmountAnimationId, in: animationNamespace)

			HStack {
				UserShortView(user: creditor.user)
					.gridCellAnchor(.leading)
					.avatarOrderIdentifier("0-creditor")
					.avatarSize(.small)
					.font(.system(size: 14))

				Spacer()
			}
		}
	}

	@ViewBuilder
	func undistributedAmountSection (_ undistributedAmount: AmountScreenModel) -> some View {
		GridRow {
			AmountView(undistributedAmount)
				.gridCellAnchor(.trailing)

			UserStandardViews.unknownUser(title: .componentsUserUndistributed)
				.gridCellAnchor(.leading)
				.avatarSize(.small)
				.font(.system(size: 14))
		}
	}

	func borrowersSection () -> some View {
		ForEach(indexedBorrowers, id: \.1.user.id) { (index, borrower) in
			GridRow {
				AmountView(borrower.amount)
					.gridCellAnchor(.trailing)

				UserShortView(user: borrower.user)
					.gridCellAnchor(.leading)
					.avatarOrderIdentifier("\(index.description)-borrower")
					.avatarSize(.small)
					.font(.system(size: 14))
			}
		}
	}
}
