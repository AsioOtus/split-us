import Foundation

public struct UserAmounts: Hashable, Codable {
	public let user: User.Compact
	public let amounts: [Amount]
	
	public init (
		user: User.Compact,
		amounts: [Amount]
	) {
		self.user = user
		self.amounts = amounts
	}
}
