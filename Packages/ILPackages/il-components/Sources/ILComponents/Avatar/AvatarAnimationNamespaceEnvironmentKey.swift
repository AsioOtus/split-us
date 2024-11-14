import SwiftUI

public enum AvatarAnimationNamespaceEnvironmentKey: EnvironmentKey {
	public static var defaultValue: Namespace.ID?
}

public extension EnvironmentValues {
	var avatarAnimationNamespace: Namespace.ID? {
		get { self[AvatarAnimationNamespaceEnvironmentKey.self] }
		set { self[AvatarAnimationNamespaceEnvironmentKey.self] = newValue }
	}
}

public extension View {
	func avatarAnimationNamespace (
		_ namespace: Namespace.ID
	) -> some View {
		environment(\.avatarAnimationNamespace, namespace)
	}
}
