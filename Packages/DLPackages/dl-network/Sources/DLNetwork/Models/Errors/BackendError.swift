import Multitool

public struct BackendError: Error, Codable {
	public let key: String
	public let path: Path
	public let description: String?
	public let details: [DetailsKey: String?]

	public var fullPath: Path { path.add(key) }

	public init (
		_ key: String,
		path: Path = [],
		description: String? = nil,
		details: [DetailsKey: String?] = [:]
	) {
		self.key = key
		self.path = .init(["backend", "error"]).add(path)
		self.description = description
		self.details = details
	}
}

extension BackendError: Equatable {
	public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
		lhs.key == rhs.key
	}
}
