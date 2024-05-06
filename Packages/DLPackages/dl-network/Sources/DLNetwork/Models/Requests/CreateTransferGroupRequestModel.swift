import DLModels
import Foundation

public struct CreateTransferGroupRequestModel: Codable {
	public let transferGroupContainer: TransferGroup.New.Container
	public let superTransferGroupId: UUID?
	public let userGroupId: UUID
	
	public init (
		transferGroupContainer: TransferGroup.New.Container,
		superTransferGroupId: UUID?,
		userGroupId: UUID
	) {
		self.transferGroupContainer = transferGroupContainer
		self.superTransferGroupId = superTransferGroupId
		self.userGroupId = userGroupId
	}
}
