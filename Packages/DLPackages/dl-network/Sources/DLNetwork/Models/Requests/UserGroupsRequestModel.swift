import Foundation

public struct UserGroupsRequestModel: Codable {
	public let userId: UUID

	public init (userId: UUID) {
		self.userId = userId
	}
}
