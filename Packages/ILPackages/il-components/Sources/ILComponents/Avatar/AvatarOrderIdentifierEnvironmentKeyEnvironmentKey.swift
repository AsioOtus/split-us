import SwiftUI

public enum AvatarOrderIdentifierEnvironmentKey: EnvironmentKey {
	public static var defaultValue: String?
}

public extension EnvironmentValues {
	var avatarOrderIdentifier: String? {
		get { self[AvatarOrderIdentifierEnvironmentKey.self] }
		set { self[AvatarOrderIdentifierEnvironmentKey.self] = newValue }
	}
}

public extension View {
	func avatarOrderIdentifier (
		_ id: String
	) -> some View {
		environment(\.avatarOrderIdentifier, id)
	}
}
