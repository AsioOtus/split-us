public struct TransferGroupContainer<TG, TU> {
	public let transferGroup: TG
	public let transferUnits: [TU]

	public init (
		transferGroup: TG,
		transferUnits: [TU]
	) {
		self.transferGroup = transferGroup
		self.transferUnits = transferUnits
	}
}

extension TransferGroupContainer: Codable where TG: Codable, TU: Codable { }
extension TransferGroupContainer: Equatable where TG: Equatable, TU: Equatable { }
extension TransferGroupContainer: Hashable where TG: Hashable, TU: Hashable { }
