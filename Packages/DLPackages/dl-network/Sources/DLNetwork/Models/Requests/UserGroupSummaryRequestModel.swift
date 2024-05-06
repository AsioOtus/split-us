import Foundation

public struct UserGroupSummaryRequestModel: Codable {
	public let userGroupId: UUID

	public init (userGroupId: UUID) {
		self.userGroupId = userGroupId
	}
}
