public extension TransferGroup {
	struct New: Hashable, Codable {
		public let info: TransferUnit.Info
		
		public init (
			info: TransferUnit.Info
		) {
			self.info = info
		}
	}
}
