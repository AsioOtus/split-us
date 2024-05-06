import DLModels

public struct UserGroupSummaryResponseModel: Codable {
	public let userSummaries: [UserSummary]

	public init (userSummaries: [UserSummary]) {
		self.userSummaries = userSummaries
	}
}
