import AsyncAlgorithms
import Dependencies

public enum LogoutEvent: Sendable {
	case logout(Reason)
}

extension LogoutEvent {
	public enum Reason: Sendable {
		case userAction
		case sessionExpired
	}
}

public typealias LogoutEventChannel = AsyncChannel

enum LogoutEventChannelDependencyKey: DependencyKey {
	public static var liveValue: LogoutEventChannel<LogoutEvent> {
		LogoutEventChannel()
	}
}

public extension DependencyValues {
	var logoutEventChannel: LogoutEventChannel<LogoutEvent> {
		get { self[LogoutEventChannelDependencyKey.self] }
		set { self[LogoutEventChannelDependencyKey.self] = newValue }
	}
}
