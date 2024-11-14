import Foundation

extension Expense.New {
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

extension Expense.New.Borrower: Identifiable {
	public var id: UUID {
		userId
	}
}
