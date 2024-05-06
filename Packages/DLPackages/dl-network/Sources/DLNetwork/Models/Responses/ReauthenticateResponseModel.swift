import DLModels
import Foundation

public struct ReauthenticateResponseModel: Codable {
	public let tokenPair: TokenPair
	
	public init (tokenPair: TokenPair) {
		self.tokenPair = tokenPair
	}
}
