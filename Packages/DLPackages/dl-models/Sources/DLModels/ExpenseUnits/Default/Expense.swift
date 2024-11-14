import Foundation

public struct Expense: Identifiable, Hashable, Codable {
	public let id: UUID
	public let info: ExpenseInfo
	public let totalAmount: Amount
	public let creditor: User.Compact?
	public let borrowers: [Borrower]
	public let offlineStatus: OfflineStatus
	public let creator: User.Compact

	public init (
		id: UUID,
		info: ExpenseInfo,
		totalAmount: Amount,
		creditor: User.Compact?,
		borrowers: [Borrower],
		offlineStatus: OfflineStatus,
		creator: User.Compact
	) {
		self.id = id
		self.info = info
		self.totalAmount = totalAmount
		self.creditor = creditor
		self.borrowers = borrowers
		self.offlineStatus = offlineStatus
		self.creator = creator
	}
}

public extension Expense {
	var new: New {
		.init(
			id: id,
			info: info,
			totalAmountValue: totalAmount.value,
			currencyId: totalAmount.currency.id,
			creditorId: creditor?.id,
			borrowers: borrowers.map(\.new)
		)
	}

	var update: Update {
		.init(
			id: id,
			info: info,
			totalAmountValue: totalAmount.value,
			currencyId: totalAmount.currency.id,
			creditorId: creditor?.id,
			borrowers: borrowers.map(\.update)
		)
	}
}

public extension Expense {
	var undistributedAmount: Amount? {
		guard let amount = totalAmount.value else { return nil }
		let amountValue = amount - borrowers.compactMap(\.amountValue).reduce(0, +)
		return .init(value: amountValue, currency: totalAmount.currency)
	}

	var nonZeroUndistributedAmount: Amount? {
		undistributedAmount?.value.flatMap { $0 > 0 ? undistributedAmount : nil }
	}
}
