import Foundation

public struct UserGroup: Hashable {
	public let id: UUID
	public let name: String
	public let defaultCurrency: Currency
	public let isPinned: Bool

	public init (
		id: UUID,
		name: String,
		defaultCurrency: Currency,
		isPinned: Bool = false
	) {
		self.id = id
		self.name = name
		self.defaultCurrency = defaultCurrency
		self.isPinned = isPinned
	}
}

public extension UserGroup {
	func setIsPinned (_ isPinned: Bool) -> Self {
		.init(
			id: id,
			name: name,
			defaultCurrency: defaultCurrency,
			isPinned: isPinned
		)
	}
}
