import Foundation

public extension Bundle {
	func appVersion () -> String? {
		infoDictionary?["CFBundleShortVersionString"] as? String
	}

	func buildNumber () -> String? {
		infoDictionary?[kCFBundleVersionKey as String] as? String
	}
}
