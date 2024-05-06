import Foundation

public struct ReauthenticateRequestModel: Codable {
	public let userId: UUID
	public let refreshToken: String
	
	public init (userId: UUID, refreshToken: String) {
		self.userId = userId
		self.refreshToken = refreshToken
	}
}
