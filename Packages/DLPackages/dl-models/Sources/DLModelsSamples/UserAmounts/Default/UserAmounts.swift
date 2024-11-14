import DLModels

public extension UserAmounts {
	static let alexander = Self(
		user: .alexander,
		amounts: [
			.eur(100),
			.usd(100),
		]
	)

	static let valdis = Self(
		user: .valdis,
		amounts: [
			.eur(100),
			.usd(100),
		]
	)

	static let daniel = Self(
		user: .daniel,
		amounts: [
			.eur(100),
			.usd(100),
		]
	)

	static let ignat = Self(
		user: .ignat,
		amounts: [
			.rub(100),
		]
	)

	static var all: [Self] {
		[
			.alexander,
			.valdis,
			.daniel,
		]
	}
}
