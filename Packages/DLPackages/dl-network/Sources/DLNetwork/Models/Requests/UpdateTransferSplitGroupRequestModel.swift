import DLModels
import Foundation

public struct UpdateTransferSplitGroupRequestModel: Codable {
	public let transferSplitGroup: TransferSplitGroup.Update

	public init (
		transferSplitGroup: TransferSplitGroup.Update
	) {
		self.transferSplitGroup = transferSplitGroup
	}
}
