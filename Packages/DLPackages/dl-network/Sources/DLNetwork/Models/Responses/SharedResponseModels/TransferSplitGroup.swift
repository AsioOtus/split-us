import DLModels

extension SharedResponseModels {
	public struct TransferSplitGroup: Codable, Equatable {
		public let transferSplitGroup: DLModels.TransferSplitGroup

		public init (transferSplitGroup: DLModels.TransferSplitGroup) {
			self.transferSplitGroup = transferSplitGroup
		}
	}
}
