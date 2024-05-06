public struct ContactSearchRequestModel: Codable {
	public let username: String
	
	public init (username: String) {
		self.username = username
	}
}
