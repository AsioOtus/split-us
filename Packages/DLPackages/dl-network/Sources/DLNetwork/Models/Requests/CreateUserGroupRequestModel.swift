import DLModels
import Foundation

public struct CreateUserGroupRequestModel: Codable {
	public let userGroup: UserGroup.New
	
	public init (userGroup: UserGroup.New) {
		self.userGroup = userGroup
	}
}
