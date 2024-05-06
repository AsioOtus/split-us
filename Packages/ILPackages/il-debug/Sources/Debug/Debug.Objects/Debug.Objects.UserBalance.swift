import DLModels

extension UserSummary {
	static let ostap = Self(
		user: .ostap,
		relatedUserAmounts: [
			.init(user: .boris, amounts: [.eur100]),
			.init(user: .valdis, amounts: [.eur100]),
			.init(user: .alexander, amounts: [.eur100]),
		]
	)

	static let boris = Self(
		user: .boris,
		relatedUserAmounts: [
			.init(user: .ostap, amounts: [.eur100]),
			.init(user: .valdis, amounts: [.usd10]),
			.init(user: .alexander, amounts: [.eur100]),
		]
	)

	static let alexander = Self(
		user: .alexander,
		relatedUserAmounts: [
			.init(user: .boris, amounts: [.eur100]),
			.init(user: .valdis, amounts: [.eur100]),
			.init(user: .ostap, amounts: [.eur100]),
		]
	)
}
