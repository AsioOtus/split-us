import SwiftUI

enum UserStackSizeEnvironmentKey: EnvironmentKey {
	static let defaultValue = Int?.none
}

extension EnvironmentValues {
	var userStackSize: Int? {
		get { self[UserStackSizeEnvironmentKey.self] }
		set { self[UserStackSizeEnvironmentKey.self] = newValue }
	}
}

extension View {
	func userStackSize (_ size: Int?) -> some View {
		environment(\.userStackSize, size)
	}
}
