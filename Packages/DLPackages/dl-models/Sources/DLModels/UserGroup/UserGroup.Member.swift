extension UserGroup {
	public struct Member {
		public let user: User.Compact
		public let role: Role

		public init (
			user: User.Compact,
			role: Role
		) {
			self.user = user
			self.role = role
		}
	}
}
