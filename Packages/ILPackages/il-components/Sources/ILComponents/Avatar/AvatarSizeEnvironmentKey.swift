import SwiftUI

public struct AvatarSize: Hashable, CaseIterable {
	public static let allCases: [Self] = [
		.mini,
		.small,
		.regular,
		.large,
		.extraLarge,
	]

	public static let mini = Self(value: 16)
	public static let small = Self(value: 20)
	public static let regular = Self(value: 28)
	public static let large = Self(value: 48)
	public static let extraLarge = Self(value: 72)

	public let value: Double

	public init (value: Double) {
		self.value = value
	}
}

enum AvatarSizeEnvironmentKey: EnvironmentKey {
	public static var defaultValue = AvatarSize.regular
}

public extension EnvironmentValues {
	var avatarSize: AvatarSize {
		get { self[AvatarSizeEnvironmentKey.self] }
		set { self[AvatarSizeEnvironmentKey.self] = newValue }
	}
}

public extension View {
	func avatarSize (
		_ size: AvatarSize
	) -> some View {
		environment(\.avatarSize, size)
	}
}
