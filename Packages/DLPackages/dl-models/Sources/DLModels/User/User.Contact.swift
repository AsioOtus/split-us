public extension User {
	struct Contact: Hashable, Codable {
		public let user: User.Compact
		public let isContact: Bool
		
		public init (
			user: User.Compact,
			isContact: Bool
		) {
			self.user = user
			self.isContact = isContact
		}
	}
}
