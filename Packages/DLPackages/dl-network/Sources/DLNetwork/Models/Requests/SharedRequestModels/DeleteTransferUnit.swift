import Foundation

extension SharedRequestModels {
	public struct DeleteTransferUnit: Codable {
		public let transferUnitId: UUID

		public init (transferUnitId: UUID) {
			self.transferUnitId = transferUnitId
		}
	}
}
