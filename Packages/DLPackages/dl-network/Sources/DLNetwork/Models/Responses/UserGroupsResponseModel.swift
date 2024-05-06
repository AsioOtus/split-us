import Foundation

public struct UserGroupsResponseModel: Codable {
	public let userGroups: [SharedResponsesSubmodels.UserGroup]

	public init (userGroups: [SharedResponsesSubmodels.UserGroup]) {
		self.userGroups = userGroups
	}
}
