import DLModels
import Foundation

public struct ContactsResponseModel: Codable {
	public let users: [User.Compact]
	
	public init (users: [User.Compact]) {
		self.users = users
	}
}
