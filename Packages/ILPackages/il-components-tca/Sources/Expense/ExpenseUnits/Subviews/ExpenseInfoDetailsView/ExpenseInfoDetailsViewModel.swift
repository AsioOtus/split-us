import ILModels
import Foundation

class ExpenseInfoDetailsViewModel: ObservableObject {
	let expenseInfo: ExpenseScreenModel

	var creditorParticipant: ExpenseParticipantScreenModel? {
		if
			let creditor = expenseInfo.creditors.first,
			let amount = expenseInfo.amounts.first {
			.init(
				user: creditor,
				amount: amount
			)
		} else {
			nil
		}
	}

	var date: String? {
		expenseInfo.expenseInfo.date.flatMap {
			DateFormatter
				.with(time: $0.hasTime() == true)
				.string(for: $0)
		}
	}

	init (
		expenseInfo: ExpenseScreenModel
	) {
		self.expenseInfo = expenseInfo
	}
}
