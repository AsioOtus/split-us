import DLModels

public struct UserGroupTransfersResponseModel: Codable {
	public let transferUnits: [TransferUnit]

	public init (transferUnits: [TransferUnit]) {
		self.transferUnits = transferUnits
	}
}
