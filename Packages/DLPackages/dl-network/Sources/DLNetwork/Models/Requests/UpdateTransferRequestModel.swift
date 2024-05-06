import DLModels

public struct UpdateTransferRequestModel: Codable {
	public let transfer: Transfer.Update
	
	public init (
		transfer: Transfer.Update
	) {
		self.transfer = transfer
	}
}
