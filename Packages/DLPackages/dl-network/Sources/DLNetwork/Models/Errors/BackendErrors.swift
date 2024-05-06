import Multitool

public extension BackendError {
	static let invalidAccessToken = Self(
		"invalidToken",
		path: .authentication
	)

	static let expiredAccessToken = Self(
		"expiredToken",
		path: .authentication
	)

	static let reauthenticationFailed = Self(
		"reauthenticationFailed",
		path: .authentication
	)

	static let invalidAuthenticationCredentials = Self(
		"invalidAuthenticationCredentials",
		path: .authentication
	)

	static let unauthorized = Self(
		"unauthorized",
		path: .access
	)

	static let forbidden = Self(
		"forbidden",
		path: .access
	)

	static let incorrectUsernameOrPassword = Self(
		"incorrectUsernameOrPassword",
		path: .login
	)

	static let usernameAlreadyExists = Self(
		"usernameAlreadyExists",
		path: .registration
	)

	static let invalidPassword = Self(
		"invalidPassword",
		path: .registration
	)
}

public extension BackendError {
	static func general (description: String) -> Self {
		.init(
			"general",
			description: description
		)
	}

	static func inner (description: String? = nil, details: [DetailsKey: String] = [:]) -> Self {
		.init(
			"inner",
			description: description,
			details: details
		)
	}

	static func requestDecodingFailure (description: String? = nil, details: [DetailsKey: String] = [:]) -> Self {
		.init(
			"requestDecodingFailure",
			description: description,
			details: details
		)
	}
}
