import Foundation
import Multitool

public struct ExpenseGroup: Identifiable, Hashable, Codable {
	public let id: UUID
	public let info: ExpenseInfo
	public let offlineStatus: OfflineStatus
	public let creator: User.Compact

	public init (
		id: UUID,
		info: ExpenseInfo,
		offlineStatus: OfflineStatus,
		creator: User.Compact
	) {
		self.id = id
		self.info = info
		self.offlineStatus = offlineStatus
		self.creator = creator
	}
}

public extension ExpenseGroup {
	var new: New {
		.init(
			id: id,
			info: info
		)
	}

	var update: Update {
		.init(
			id: id,
			info: info
		)
	}
}

public extension Array where Element == ExpenseTree {
	var amounts: [Amount] {
		flatMap { $0.amounts }.compactMap { $0 }
	}

	var amountsSum: [Amount] {
		var dictionary = [Currency: Int]()
		amounts
			.compactMap { $0 }
			.forEach { dictionary[$0.currency, default: 0] += $0.valueOrZero }

		let amountsSum = dictionary.map { currency, value in Amount(value: value, currency: currency) }
		return amountsSum
	}

	var singleCurrency: Currency? {
		amountsSum.count == 1 ? amountsSum.first?.currency : nil
	}

	var isSingleCurrency: Bool {
		singleCurrency != nil
	}

	var creditors: [User.Compact] {
		flatMap { $0.creditors }.compactMap { $0 }
	}

	var uniqueCreditors: [User.Compact] {
		creditors.duplicatesRemoved(\.id)
	}

	var singleCreditor: User.Compact? {
		uniqueCreditors.count == 1 ? uniqueCreditors.first : nil
	}

	var isSingleCreditor: Bool {
		singleCreditor != nil
	}

	var borrowers: [Expense.Borrower] {
		flatMap { $0.borrowers }.compactMap { $0 }
	}

	var uniqueBorrowers: [Expense.Borrower] {
		borrowers.duplicatesRemoved(\.id)
	}

	var hasDuplicatedBorrowers: Bool {
		uniqueBorrowers.count != borrowers.count
	}
}
