import DLModels
import Foundation
import ILFormatters
import ILModels

extension ExpenseScreenModel {
	public struct Mapper {
		public static let `default` = Self()

		let currencyFormatter = NumberFormatter.currency
		let userScreenModelMapper = UserScreenModel.Mapper.default
		let borrowerMapper = ExpenseParticipantScreenModel.Mapper.default
	}
}

public extension ExpenseScreenModel.Mapper {
	func map (_ expense: Expense) -> ExpenseScreenModel {
		.init(
			id: expense.id,
			expenseInfo: expense.info,
			offlineStatus: expense.offlineStatus,
			amounts: [
				currencyFormatter.format(expense.totalAmount)
			],
			undistributedAmounts: expense.nonZeroUndistributedAmount.map(currencyFormatter.format).map { [$0] } ?? [],
			creditors: expense.creditor.map {
				[userScreenModelMapper.map($0)]
			} ?? [],
			borrowers: expense.borrowers.map {
				borrowerMapper.map(
					$0,
					currencyFormatter: currencyFormatter.copy(
						currencyCode: expense.totalAmount.currency.code
					)
				)
			}
		)
	}

	func map (_ expenseGroup: ExpenseGroup) -> ExpenseScreenModel {
		.init(
			id: expenseGroup.id,
			expenseInfo: expenseGroup.info,
			offlineStatus: expenseGroup.offlineStatus,
			amounts: [],
			undistributedAmounts: [],
			creditors: [],
			borrowers: []
		)
	}

	func map (_ expenseGroupContainer: ExpenseGroup.Container) -> ExpenseScreenModel {
		.init(
			id: expenseGroupContainer.expenseGroup.id,
			expenseInfo: expenseGroupContainer.expenseGroup.info,
			offlineStatus: expenseGroupContainer.expenseGroup.offlineStatus,
			amounts: expenseGroupContainer.expenseTrees.amountsSum.map(currencyFormatter.format),
			undistributedAmounts: [],
			creditors: expenseGroupContainer.expenseTrees.uniqueCreditors.map(userScreenModelMapper.map),
			borrowers: expenseGroupContainer.expenseTrees.uniqueBorrowers.map {
				borrowerMapper.map($0, currencyFormatter: currencyFormatter)
			}
		)
	}
}
