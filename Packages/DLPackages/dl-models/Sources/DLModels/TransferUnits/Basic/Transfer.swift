import Foundation

public struct Transfer: Identifiable, Hashable, Codable {
	public let id: UUID
	public let info: TransferUnit.Info
	public let amount: Amount
	public let creditor: User.Compact?
	public let borrower: User.Compact?
	
	public init (
		id: UUID,
		info: TransferUnit.Info,
		amount: Amount,
		creditor: User.Compact?,
		borrower: User.Compact?
	) {
		self.id = id
		self.info = info
		self.amount = amount
		self.creditor = creditor
		self.borrower = borrower
	}
}

public extension Transfer {
	var new: New {
		.init(
			info: info,
			amountValue: amount.value,
			currencyId: amount.currency.id,
			creditorId: creditor?.id,
			borrowerId: borrower?.id
		)
	}
	
	var update: Update {
		.init(
			id: id,
			info: info,
			amountValue: amount.value,
			currencyId: amount.currency.id,
			creditorId: creditor?.id,
			borrowerId: borrower?.id
		)
	}
}
