import Multitool

public extension TransferUnit {
	typealias Update = GeneralTree<TransferUnitValue.Update>
}

public extension TransferUnit.Update {
	var info: TransferUnit.Info {
		switch self.value {
		case .transfer(let transfer): transfer.info
		case .transferGroup(let transferGroup): transferGroup.info
		case .transferSplitGroup(let transferSplitGroup): transferSplitGroup.info
		}
	}
}
