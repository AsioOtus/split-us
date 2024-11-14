import ILModels
import SwiftUI

struct ExpenseInfoDetailsView: View {
	let vm: ExpenseInfoDetailsViewModel

	let participantsAnimation: Namespace.ID

	init(
		expenseInfo: ExpenseScreenModel,
		participantsAnimation: Namespace.ID
	) {
		self.vm = .init(
			expenseInfo: expenseInfo
		)
		self.participantsAnimation = participantsAnimation
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			if let note = vm.expenseInfo.expenseInfo.note {
				noteView(note)
					.padding(.horizontal, 12)

				Divider()
					.foregroundStyle(.background)
			}

			participantsView()
				.padding(.horizontal, 12)
		}
		.padding(.vertical, 12)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
		.background {
			RoundedRectangle(cornerRadius: 6)
				.fill(.background.secondary)
		}
	}
}

private extension ExpenseInfoDetailsView {
	func noteView (_ note: String) -> some View {
		let icon = Text(
			Image(systemName: "note.text")
		)
			.fontWeight(.medium)
			.foregroundStyle(.tint)

		let note = Text(note)

		return Text("\(icon) \(note)")
			.font(.footnote)
			.imageScale(.small)
	}

	func participantsView () -> some View {
		ExpenseParticipantsView(
			creditor: vm.creditorParticipant,
			borrowers: vm.expenseInfo.borrowers,
			undistributedAmount: vm.expenseInfo.undistributedAmounts.first,
			animationNamespace: participantsAnimation
		)
	}
}
