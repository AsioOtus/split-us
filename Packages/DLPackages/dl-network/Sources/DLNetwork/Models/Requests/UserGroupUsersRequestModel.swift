import Foundation

public struct UserGroupUsersRequestModel: Codable {
	public let userGroupId: UUID
	
	public init (userGroupId: UUID) {
		self.userGroupId = userGroupId
	}
}
