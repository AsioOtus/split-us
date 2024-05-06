extension TransferGroup {
	public typealias Container = TransferGroupContainer<TransferGroup, TransferUnit>
}

public extension TransferGroup.Container {
	var transferUnit: TransferUnit {
		.init(
			transferGroup: transferGroup,
			transferUnits: transferUnits
		)
	}
}
