import SwiftUI

public struct FilledButtonStyle: ButtonStyle {
	public func makeBody (configuration: Configuration) -> some View {
		configuration.label
			.overlay(
				Circle()
					.strokeBorder(Color.blue, lineWidth: 1)
			)
	}
}

public extension ButtonStyle where Self == FilledButtonStyle {
	static func circle () -> FilledButtonStyle {
		FilledButtonStyle()
	}
}
