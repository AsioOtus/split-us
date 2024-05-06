import DLModels

extension SharedResponseModels {
	public struct TransferGroup: Codable, Equatable {
		public let transferGroupContainer: DLModels.TransferGroup.Container

		public init (
			transferGroupContainer: DLModels.TransferGroup.Container
		) {
			self.transferGroupContainer = transferGroupContainer
		}
	}
}
