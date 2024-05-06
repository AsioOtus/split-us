public enum AnalyticsEvent {
	case appStarted

	case login(mode: LoginMode, username: String)
	case logout(username: String?)

	case registrationCompleted

	public var key: String {
		switch self {
		case .appStarted: "appStarted"

		case .login: "login"
		case .logout: "logout"

		case .registrationCompleted: "registrationCompleted"
		}
	}

	public var parameters: [ParameterKey: String] {
		switch self {
		case .appStarted: [:]

		case .login(let mode, let username): [
			.loginMode: mode.rawValue,
			.username: username
		]
		case .logout(let username): username.map { [.username: $0] } ?? [:]

		case .registrationCompleted: [:]
		}
	}

	public var rawParameters: [String: String] {
		.init(uniqueKeysWithValues: parameters.map { key, value in (key.rawValue, value) })
	}
}

extension AnalyticsEvent {
	public enum ParameterKey: String {
		case loginMode
		case username
	}
}

extension AnalyticsEvent {
	public enum LoginMode: String {
		case initial
		case silent
	}
}
