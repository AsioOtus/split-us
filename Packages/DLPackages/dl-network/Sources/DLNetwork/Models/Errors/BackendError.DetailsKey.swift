extension BackendError {
	public struct DetailsKey: Codable, Hashable {
		public let key: String

		public init (_ key: String) {
			self.key = key
		}
	}
}

extension BackendError.DetailsKey: ExpressibleByStringLiteral {
	public init (stringLiteral: String) {
		self.init(stringLiteral)
	}
}

extension BackendError.DetailsKey: RawRepresentable {
	public var rawValue: String { key }

	public init? (rawValue: String) {
		self.init(rawValue)
	}
}

public extension BackendError.DetailsKey {
	static let message: Self = "message"
	static let localizationKey: Self = "localizationKey"
}
