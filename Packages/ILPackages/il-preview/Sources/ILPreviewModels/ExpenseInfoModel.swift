import ILModels

public extension ExpenseScreenModel {
	static let exampleA = Self(
		id: .init(),
		expenseInfo: .init(
			name: "Пиво",
			note: nil,
			date: .init(timeIntervalSince1970: 1719835200),
			coordinate: nil
		),
		offlineStatus: .cached,
		amounts: [
			"12€"
		],
		undistributedAmounts: [
			"3€",
		],
		creditors: [
			.alexander
		],
		borrowers: [
			.init(
				user: .ostap,
				amount: "4€"
			),
			.init(
				user: .valdis,
				amount: "4€"
			),
			.init(
				user: .ignat,
				amount: "4€"
			),
		]
	)
}
