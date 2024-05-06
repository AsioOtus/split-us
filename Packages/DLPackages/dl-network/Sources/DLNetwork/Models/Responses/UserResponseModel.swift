import DLModels

public struct UserResponseModel: Codable {
	public let user: User
	
	public init (user: User) {
		self.user = user
	}
}
