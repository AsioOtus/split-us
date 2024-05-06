public struct UsernameFormatter {
	public static let `default` = Self()

	public func format (_ username: String) -> String {
		"@" + username
	}
}
