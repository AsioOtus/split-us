import DLModels

public struct UserUsernameSearchResponseModel: Codable {
	public let user: User?
	
	public init (user: User?) {
		self.user = user
	}
}
