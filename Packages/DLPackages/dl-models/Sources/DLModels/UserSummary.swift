public struct UserSummary: Hashable, Codable {
	public let user: User.Compact
	public let relatedUserAmounts: [UserAmounts]
	
	public var totalAmount: [Amount] {
		relatedUserAmounts.flatMap { $0.amounts }.reduced()
	}
	
	public init (
		user: User.Compact,
		relatedUserAmounts: [UserAmounts]
	) {
		self.user = user
		self.relatedUserAmounts = relatedUserAmounts
	}
}
