import Foundation

extension TransferSplitGroup {
	public struct Update: Hashable, Codable {
		public let id: UUID
		public let info: TransferUnit.Info
		public let amountValue: Int?
		public let currencyId: UUID
		public let creditorId: UUID?
		public let borrowerAmounts: [UUID: Int?]

		public init (
			id: UUID,
			info: TransferUnit.Info,
			amountValue: Int?,
			currencyId: UUID,
			creditorId: UUID?,
			borrowerAmounts: [UUID: Int?]
		) {
			self.id = id
			self.info = info
			self.amountValue = amountValue
			self.currencyId = currencyId
			self.creditorId = creditorId
			self.borrowerAmounts = borrowerAmounts
		}
	}
}
