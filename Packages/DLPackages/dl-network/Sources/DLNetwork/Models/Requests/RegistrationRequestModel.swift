import DLModels
import Foundation

public struct RegistrationRequestModel: Codable {
	public let user: User.New
	
	public init (user: User.New) {
		self.user = user
	}
}
