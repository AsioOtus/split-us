public enum ConnectionState: String {
	case online
	case offline

	public var isOnline: Bool { self == .online }
	public var isOffline: Bool { self == .offline }
}
