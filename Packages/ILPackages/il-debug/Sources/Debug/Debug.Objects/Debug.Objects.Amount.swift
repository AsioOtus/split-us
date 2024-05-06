import DLModels

extension Debug.Objects {
	struct Amounts {
		static let `default` = Self()

		let eur10 = Amount(value: 10, currency: .eur)
		let eur100 = Amount(value: 100, currency: .eur)
		let eur200 = Amount(value: 200, currency: .eur)
		let eur10_000 = Amount(value: 10_000, currency: .eur)

		let usd10 = Amount(value: 10, currency: .usd)
		let usd100 = Amount(value: 100, currency: .usd)
		let usd200 = Amount(value: 200, currency: .usd)
		let usd10_000 = Amount(value: 10_000, currency: .usd)
	}
}

public extension Amount {
	static let eur10 = Self(value: 10, currency: .eur)
	static let eur100 = Self(value: 100, currency: .eur)
	static let eur200 = Self(value: 200, currency: .eur)
	static let eur10_000 = Self(value: 10_000, currency: .eur)

	static let usd10 = Self(value: 10, currency: .usd)
	static let usd100 = Self(value: 100, currency: .usd)
	static let usd200 = Self(value: 200, currency: .usd)
	static let usd10_000 = Self(value: 10_000, currency: .usd)
}
