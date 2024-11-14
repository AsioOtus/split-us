import DLModels

public extension UserSummary {
	static let ignat = Self(
		user: .ignat,
		relatedUserAmounts: [
			.valdis,
			.alexander,
			.daniel,
		]
	)

	static let valdis = Self(
		user: .valdis,
		relatedUserAmounts: [
			.ignat,
			.alexander,
			.daniel,
		]
	)

	static let daniel = Self(
		user: .daniel,
		relatedUserAmounts: [
			.valdis,
			.alexander,
			.ignat,
		]
	)

	static var all: [Self] {
		[
			.ignat,
			.valdis,
			.daniel,
		]
	}
}
