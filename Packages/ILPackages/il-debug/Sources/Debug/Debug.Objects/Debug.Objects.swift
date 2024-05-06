import DLModels

public extension Currency {
	static let rub = Self(id: .create(1), code: "RUB")
	static let eur = Self(id: .create(2), code: "EUR")
	static let usd = Self(id: .create(3), code: "USD")
}

extension Debug {
	public struct Objects {
		static let standard = Self()
	}
}
