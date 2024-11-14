import Multitool

public enum OfflineStatus: String, CaseCheckable {
	case cached
	case offlineCreated

	public var isCached: Bool { self == .cached }
	public var isOfflineCreated: Bool { self == .offlineCreated }
}

extension OfflineStatus: Hashable { }
extension OfflineStatus: Codable { }
