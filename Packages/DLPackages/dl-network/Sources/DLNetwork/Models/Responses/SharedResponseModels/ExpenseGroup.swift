import DLModels

extension SharedResponseModels {
	public struct ExpenseGroup: Codable, Equatable {
		public let expenseGroupContainer: DLModels.ExpenseGroup.Container

		public init (
			expenseGroupContainer: DLModels.ExpenseGroup.Container
		) {
			self.expenseGroupContainer = expenseGroupContainer
		}
	}
}
