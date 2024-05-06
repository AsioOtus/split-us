import Foundation

extension User {
	public struct Compact: Hashable, Codable {
		public let id: UUID
		public let username: String
		public let name: String?
		public let surname: String?
		
		public init (
			id: UUID,
			username: String,
			name: String?,
			surname: String?
		) {
			self.id = id
			self.username = username
			self.name = name
			self.surname = surname
		}
	}
}
