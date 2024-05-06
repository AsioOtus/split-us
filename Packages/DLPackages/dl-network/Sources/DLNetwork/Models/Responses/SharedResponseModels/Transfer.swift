import DLModels

extension SharedResponseModels {
	public struct Transfer: Codable, Equatable {
		public let transfer: DLModels.Transfer

		public init (transfer: DLModels.Transfer) {
			self.transfer = transfer
		}
	}
}
