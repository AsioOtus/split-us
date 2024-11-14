import DLModels
import Foundation
import ILModels

extension ExpenseParticipantScreenModel {
	public struct Mapper {
		public static let `default` = Self()
		
		let userMapper = UserScreenModel.Mapper.default
	}
}

public extension ExpenseParticipantScreenModel.Mapper {
	func map (_ borrower: Expense.Borrower, currencyFormatter: NumberFormatter) -> ExpenseParticipantScreenModel {
		.init(
			user: userMapper.map(borrower.user),
			amount: currencyFormatter.format(borrower.amountValue)
		)
	}
}
