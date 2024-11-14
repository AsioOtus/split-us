import Foundation

public struct User: Hashable, Codable {
	public let id: UUID
	public let username: String
	public let email: String
	public let name: String?
	public let surname: String?
	
	public init (
		id: UUID,
		username: String,
		email: String,
		name: String?,
		surname: String?
	) {
		self.id = id
		self.username = username
		self.email = email
		self.name = name
		self.surname = surname
	}
	
	public var compact: User.Compact {
		.init(
			id: id,
			username: username,
			name: name,
			surname: surname
		)
	}
}
