import Foundation
import DLModels

public struct UserGroupUsersResponseModel: Codable {
	public let users: [User.Compact]
	
	public init (users: [User.Compact]) {
		self.users = users
	}
}
