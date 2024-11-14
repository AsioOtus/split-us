import ILUtils
import SwiftUI

public struct MapButtonStyle: ButtonStyle {
	public func makeBody (configuration: Configuration) -> some View {
		configuration.label
			.labelStyle(.iconOnly)
			.padding(2)
			.background(.background.tertiary)
			.backgroundStyle(.thickMaterial)
			.roundedCorners(4)
	}
}

public extension ButtonStyle where Self == MapButtonStyle {
	static var map: Self {
		MapButtonStyle()
	}
}
