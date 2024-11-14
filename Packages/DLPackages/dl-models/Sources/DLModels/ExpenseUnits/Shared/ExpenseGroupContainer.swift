public struct ExpenseGroupContainer<EG, ET> {
	public let expenseGroup: EG
	public let expenseTrees: [ET]

	public init (
		expenseGroup: EG,
		expenseTrees: [ET]
	) {
		self.expenseGroup = expenseGroup
		self.expenseTrees = expenseTrees
	}
}

extension ExpenseGroupContainer: Codable where EG: Codable, ET: Codable { }
extension ExpenseGroupContainer: Equatable where EG: Equatable, ET: Equatable { }
extension ExpenseGroupContainer: Hashable where EG: Hashable, ET: Hashable { }
