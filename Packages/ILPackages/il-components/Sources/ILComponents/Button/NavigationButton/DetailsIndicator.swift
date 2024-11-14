import SwiftUI

public struct DetailsIndicator {
	public static func view () -> some View {
		Image(systemName: "chevron.forward")
			.foregroundStyle(.tertiary)
			.fontWeight(.semibold)
			.font(.system(size: 14))
	}

	public static func text () -> Text {
		Text("\(Image(systemName: "chevron.forward"))")
			.foregroundStyle(.secondary)
			.fontWeight(.semibold)
			.font(.system(size: 14))
	}
}
