import Foundation

public struct TransferSplitGroup: Identifiable, Hashable, Codable {
	public let id: UUID
	public let info: TransferUnit.Info
	public let amount: Amount
	public let creditor: User.Compact?
	public let borrowerAmounts: [User.Compact: Int?]

	public init (
		id: UUID,
		info: TransferUnit.Info,
		amount: Amount,
		creditor: User.Compact?,
		borrowerAmounts: [User.Compact: Int?]
	) {
		self.id = id
		self.info = info
		self.amount = amount
		self.creditor = creditor
		self.borrowerAmounts = borrowerAmounts
	}
}

public extension TransferSplitGroup {
	var new: New {
		.init(
			info: info,
			amountValue: amount.value,
			currencyId: amount.currency.id,
			creditorId: creditor?.id,
			borrowerAmounts: .init(
				uniqueKeysWithValues: borrowerAmounts.map { ($0.id, $1) }
			)
		)
	}

	var update: Update {
		.init(
			id: id,
			info: info,
			amountValue: amount.value,
			currencyId: amount.currency.id,
			creditorId: creditor?.id,
			borrowerAmounts: .init(
				uniqueKeysWithValues: borrowerAmounts.map { ($0.id, $1) }
			)
		)
	}
}
