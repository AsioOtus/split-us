import Foundation

public struct RemoveContactRequestModel: Codable {
	public let userId: UUID
	
	public init (userId: UUID) {
		self.userId = userId
	}
}
