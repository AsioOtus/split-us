public struct AppVersionFormatter {
	public static let `default` = Self()

	public func format (version: String?, buildNumber: String?) -> String? {
		let nonNilComponents = [version, buildNumber].compactMap { $0 }
		return !nonNilComponents.isEmpty ? nonNilComponents.joined(separator: ".") : nil
	}
}
