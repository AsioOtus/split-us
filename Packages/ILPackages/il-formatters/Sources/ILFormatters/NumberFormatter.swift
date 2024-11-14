import DLModels
import Foundation

public extension NumberFormatter {
	static let numberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.minimumIntegerDigits = 1
		formatter.maximumFractionDigits = 3
		formatter.minimumFractionDigits = 2
		return formatter
	}()
}

public extension NumberFormatter {
	static let emptyCurrencyPlaceholder = "-"

	static let currency: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		return formatter
	}()

	func copy (currencyCode: String, locale: Locale = .current) -> Self {
		let currencyFormatter = copy() as! Self
		currencyFormatter.locale = locale
		currencyFormatter.currencyCode = currencyCode
		return currencyFormatter
	}

	func format (_ value: Double) -> String? {
		string(from: value as NSNumber)
	}

	func format (_ value: Double) -> String {
		format(value) ?? Self.emptyCurrencyPlaceholder
	}

	func format (_ value: Double?) -> String {
		value.map(format) ?? Self.emptyCurrencyPlaceholder
	}

	func format (_ value: Int) -> String? {
		string(from: value as NSNumber)
	}

	func format (_ value: Int) -> String {
		format(value) ?? Self.emptyCurrencyPlaceholder
	}

	func format (_ value: Int?) -> String {
		value.map(format) ?? Self.emptyCurrencyPlaceholder
	}

	func format (_ amount: Amount) -> String? {
		amount.value.flatMap {
			self
				.copy(currencyCode: amount.currency.code)
				.format($0)
		}
	}

	func format (_ amount: Amount) -> String {
		format(amount) ?? Self.emptyCurrencyPlaceholder
	}

	func format (_ amount: Amount?) -> String {
		amount.map(format) ?? Self.emptyCurrencyPlaceholder
	}
}

public extension NumberFormatter {
	static let integer: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 0
		return formatter
	}()
}

public extension NumberFormatter {
	static let percent: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent
		formatter.minimumIntegerDigits = 1
		formatter.maximumFractionDigits = 3
		formatter.minimumFractionDigits = 0
		return formatter
	}()
}
