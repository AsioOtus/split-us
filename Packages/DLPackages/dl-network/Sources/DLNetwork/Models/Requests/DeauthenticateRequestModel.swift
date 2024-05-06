import Foundation

public struct DeauthenticateRequestModel: Codable {
	public let refreshToken: String
	
	public init (refreshToken: String) {
		self.refreshToken = refreshToken
	}
}
