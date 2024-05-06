import Foundation

public enum TransferUnitValue<T, TG, TSG> {
	case transfer(T)
	case transferGroup(TG)
	case transferSplitGroup(TSG)

	public var isTransfer: Bool {
		if case .transfer = self { true }
		else { false }
	}

	public var isTransferGroup: Bool {
		if case .transferGroup = self { true }
		else { false }
	}

	public var isSplit: Bool {
		if case .transferSplitGroup = self { true }
		else { false }
	}

	public var transferValue: T? {
		if case .transfer(let value) = self { return value }
		else { return nil }
	}

	public var transferGroupValue: TG? {
		if case .transferGroup(let value) = self { return value }
		else { return nil }
	}

	public var transferSplitGroupValue: TSG? {
		if case .transferSplitGroup(let value) = self { return value }
		else { return nil }
	}
}

extension TransferUnitValue: Identifiable where T: Identifiable<UUID>, TG: Identifiable<UUID>, TSG: Identifiable<UUID> {
	public var id: UUID {
		switch self {
		case .transfer(let t): t.id
		case .transferGroup(let tg):  tg.id
		case .transferSplitGroup(let tsg): tsg.id
		}
	}
}

extension TransferUnitValue: Codable where T: Codable, TG: Codable, TSG: Codable { }
extension TransferUnitValue: Equatable where T: Equatable, TG: Equatable, TSG: Equatable { }
extension TransferUnitValue: Hashable where T: Hashable, TG: Hashable, TSG: Hashable { }
