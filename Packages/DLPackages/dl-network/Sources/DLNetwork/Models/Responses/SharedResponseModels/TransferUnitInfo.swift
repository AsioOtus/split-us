import DLModels

extension SharedResponseModels {
	public struct TransferUnitInfo: Codable, Equatable {
		public let transferInfo: DLModels.TransferUnit.Info

		public init (transferInfo: DLModels.TransferUnit.Info) {
			self.transferInfo = transferInfo
		}
	}
}
