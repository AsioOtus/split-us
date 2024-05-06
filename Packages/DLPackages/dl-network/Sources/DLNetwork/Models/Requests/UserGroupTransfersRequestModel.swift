import Foundation

public struct UserGroupTransfersRequestModel: Codable {
	public let userGroupId: UUID

	public init (userGroupId: UUID) {
		self.userGroupId = userGroupId
	}
}
