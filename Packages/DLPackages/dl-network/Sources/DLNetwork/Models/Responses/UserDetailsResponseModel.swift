import DLModels

public struct UserDetailsResponseModel: Codable {
	public let user: User.Compact

	public init (user: User.Compact) {
		self.user = user
	}
}
