import Foundation

public struct UserDetailsRequestModel: Codable {
	public let userId: UUID

	public init (userId: UUID) {
		self.userId = userId
	}
}
