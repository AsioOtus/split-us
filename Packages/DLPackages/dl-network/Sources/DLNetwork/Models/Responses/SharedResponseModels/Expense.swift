import DLModels

extension SharedResponseModels {
	public struct Expense: Codable, Equatable {
		public let expense: DLModels.Expense

		public init (expense: DLModels.Expense) {
			self.expense = expense
		}
	}
}
