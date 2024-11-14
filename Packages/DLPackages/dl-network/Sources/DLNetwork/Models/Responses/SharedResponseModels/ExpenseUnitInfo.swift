import DLModels

extension SharedResponseModels {
	public struct ExpenseInfo: Codable, Equatable {
		public let expenseInfo: DLModels.ExpenseInfo

		public init (expenseInfo: DLModels.ExpenseInfo) {
			self.expenseInfo = expenseInfo
		}
	}
}
