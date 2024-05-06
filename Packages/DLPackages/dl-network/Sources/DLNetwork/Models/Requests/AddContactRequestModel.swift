import Foundation

public struct AddContactRequestModel: Codable {
	public let userId: UUID

	public init (userId: UUID) {
		self.userId = userId
	}
}
