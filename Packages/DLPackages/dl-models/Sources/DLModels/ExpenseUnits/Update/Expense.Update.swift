import Foundation

extension Expense {
	public struct Update: Hashable, Codable {
		public let id: UUID
		public let info: ExpenseInfo
		public let totalAmountValue: Int?
		public let currencyId: UUID
		public let creditorId: UUID?
		public let borrowers: [Borrower]

		public init (
			id: UUID,
			info: ExpenseInfo,
			totalAmountValue: Int?,
			currencyId: UUID,
			creditorId: UUID?,
			borrowers: [Borrower]
		) {
			self.id = id
			self.info = info
			self.totalAmountValue = totalAmountValue
			self.currencyId = currencyId
			self.creditorId = creditorId
			self.borrowers = borrowers
		}
	}
}
