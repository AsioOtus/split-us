import Foundation

public struct CreateUserGroupResponseModel: Codable {
	public let userGroup: SharedResponsesSubmodels.UserGroup

	public init (userGroup: SharedResponsesSubmodels.UserGroup) {
		self.userGroup = userGroup
	}
}
