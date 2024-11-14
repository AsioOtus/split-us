import Foundation

extension Expense {
	public struct Borrower: Hashable, Codable {
		public let user: User.Compact
		public let amountValue: Int?
		public let isCompleted: Bool

		public init (
			user: User.Compact,
			amountValue: Int?,
			isCompleted: Bool
		) {
			self.user = user
			self.amountValue = amountValue
			self.isCompleted = isCompleted
		}
	}
}

extension Expense.Borrower: Identifiable {
	public var id: UUID {
		user.id
	}
}

public extension Expense.Borrower {
	var new: Expense.New.Borrower {
		.init(
			userId: user.id,
			amountValue: amountValue,
			isCompleted: isCompleted
		)
	}

	var update: Expense.Update.Borrower {
		.init(
			userId: user.id,
			amountValue: amountValue,
			isCompleted: isCompleted
		)
	}
}
