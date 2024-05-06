import Foundation

public struct AddUserToUserGroupRequestModel: Codable {
	public let userGroupId: UUID
	public let users: [UUID]

	public init (
		userGroupId: UUID,
		users: [UUID]
	) {
		self.userGroupId = userGroupId
		self.users = users
	}
}
