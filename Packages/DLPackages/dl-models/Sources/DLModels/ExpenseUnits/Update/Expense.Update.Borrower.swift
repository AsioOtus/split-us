import Foundation

extension Expense.Update {
	public struct Borrower: Hashable, Codable {
		public let userId: UUID
		public let amountValue: Int?
		public let isCompleted: Bool

		public init (
			userId: UUID,
			amountValue: Int?,
			isCompleted: Bool
		) {
			self.userId = userId
			self.amountValue = amountValue
			self.isCompleted = isCompleted
		}
	}
}

extension Expense.Update.Borrower: Identifiable {
	public var id: UUID {
		userId
	}
}
