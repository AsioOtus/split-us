import DLModels

public extension Currency {
	static let eur = Self(id: .create(1), code: "eur")
	static let usd = Self(id: .create(2), code: "usd")
	static let rub = Self(id: .create(3), code: "rub")

	static let all: [Self] = [
		.eur,
		.usd,
		.rub,
	]
}
