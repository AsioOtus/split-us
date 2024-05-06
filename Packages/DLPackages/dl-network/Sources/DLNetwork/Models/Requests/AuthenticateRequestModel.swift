import Foundation

public struct AuthenticateRequestModel: Codable {
	public let username: String
	public let password: String

	public init (username: String, password: String) {
		self.username = username
		self.password = password
	}
}
