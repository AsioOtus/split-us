import DLModels

public extension Amount {
	static func rub (_ value: Int?) -> Self {
		.init(value: value, currency: .rub)
	}

	static func eur (_ value: Int?) -> Self {
		.init(value: value, currency: .eur)
	}

	static func usd (_ value: Int?) -> Self {
		.init(value: value, currency: .usd)
	}
}
