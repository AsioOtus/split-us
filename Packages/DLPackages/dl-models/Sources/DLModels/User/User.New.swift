extension User {
	public struct New: Codable {
		public let name: String
		public let email: String
		public let username: String
		public let password: String

		public init (
			name: String,
			email: String,
			username: String,
			password: String
		) {
			self.name = name
			self.email = email
			self.username = username
			self.password = password
		}

		public func set (password: String) -> Self {
			.init(name: name, email: email, username: username, password: password)
		}
	}
}
