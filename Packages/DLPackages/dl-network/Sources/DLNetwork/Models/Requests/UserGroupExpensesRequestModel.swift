import Foundation

public struct UserGroupExpensesRequestModel: Codable {
	public let userGroupId: UUID

	public init (userGroupId: UUID) {
		self.userGroupId = userGroupId
	}
}
