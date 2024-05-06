import Foundation

public struct FractionFormat: ParseableFormatStyle {
	public let denominator: String
	public var parseStrategy: Strategy = .init()

	public init (denominator: String) {
		self.denominator = denominator
	}

	public func format (_ numerator: Int) -> String {
		"\(numerator) / \(denominator)"
	}

	public struct Strategy: ParseStrategy {
		public func parse (_ value: String) throws -> Int {
			let numberPrefix = value.prefix { $0.isNumber }
			return Int(numberPrefix) ?? 0
		}
	}
}

public extension ParseableFormatStyle where Self == FractionFormat {
	static func fraction (denominator: String) -> Self {
		.init(denominator: denominator)
	}
}
