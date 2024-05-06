import DLModels
import Foundation

public struct CreateTransferRequestModel: Codable {
	public let transfer: Transfer.New
	public let superTransferGroupId: UUID?
	public let userGroupId: UUID
	
	public init (
		transfer: Transfer.New,
		superTransferGroupId: UUID?,
		userGroupId: UUID
	) {
		self.transfer = transfer
		self.superTransferGroupId = superTransferGroupId
		self.userGroupId = userGroupId
	}
}
