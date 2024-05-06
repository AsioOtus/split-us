import Foundation

public extension TransferGroup {
	struct Update: Identifiable, Hashable, Codable {
		public let id: UUID
		public let info: TransferUnit.Info
		
		public init (
			id: UUID,
			info: TransferUnit.Info
		) {
			self.id = id
			self.info = info
		}
	}
}
