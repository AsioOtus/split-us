import DLModels
import Foundation

public struct RegistrationResponseModel: Codable {
	public let tokenPair: TokenPair
	public let user: User
	
	public init (tokenPair: TokenPair, user: User) {
		self.tokenPair = tokenPair
		self.user = user
	}
}
