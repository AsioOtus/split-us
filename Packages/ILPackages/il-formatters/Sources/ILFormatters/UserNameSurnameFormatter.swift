public struct UserNameSurnameFormatter {
	public static let `default` = Self()

	public func format (name: String?, surname: String?) -> String? {
		let formatted: String = [name, surname].compactMap { $0 }.joined(separator: " ")
		return formatted.isEmpty ? nil : formatted
	}
}
