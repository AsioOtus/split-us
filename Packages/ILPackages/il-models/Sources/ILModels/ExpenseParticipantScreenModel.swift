public struct ExpenseParticipantScreenModel: Hashable {
	public let user: UserScreenModel
	public let amount: AmountScreenModel

	public init (
		user: UserScreenModel,
		amount: AmountScreenModel
	) {
		self.user = user
		self.amount = amount
	}
}
