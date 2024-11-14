import Foundation

extension SharedRequestModels {
	public struct DeleteExpenseTree: Codable {
		public let expenseTreeId: UUID

		public init (expenseTreeId: UUID) {
			self.expenseTreeId = expenseTreeId
		}
	}
}
