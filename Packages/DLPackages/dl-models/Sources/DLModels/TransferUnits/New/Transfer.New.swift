import Foundation

public extension Transfer {
	struct New: Hashable, Codable {
		public let info: TransferUnit.Info
		public let amountValue: Int?
		public let currencyId: UUID
		public let creditorId: UUID?
		public let borrowerId: UUID?
		
		public init (
			info: TransferUnit.Info,
			amountValue: Int?,
			currencyId: UUID,
			creditorId: UUID?,
			borrowerId: UUID?
		) {
			self.info = info
			self.amountValue = amountValue
			self.currencyId = currencyId
			self.creditorId = creditorId
			self.borrowerId = borrowerId
		}
	}
}
