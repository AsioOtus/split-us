import SwiftUI

enum UserRelationshipStateEnvironmentKey: EnvironmentKey {
	static var defaultValue: UserRelationshipState?
}

public extension EnvironmentValues {
	var userRelationshipState: UserRelationshipState? {
		get { self[UserRelationshipStateEnvironmentKey.self] }
		set { self[UserRelationshipStateEnvironmentKey.self] = newValue }
	}
}

public extension View {
	func userRelationshipState (
		_ role: UserRelationshipState?
	) -> some View {
		environment(\.userRelationshipState, role)
	}
}
