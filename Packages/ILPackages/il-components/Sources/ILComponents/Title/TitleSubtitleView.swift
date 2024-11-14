import SwiftUI

public struct TitleSubtitleView: View {
	let title: LocalizedStringKey
	let subtitle: LocalizedStringKey

	public init (
		title: LocalizedStringKey,
		subtitle: LocalizedStringKey
	) {
		self.title = title
		self.subtitle = subtitle
	}

	public var body: some View {
		VStack {
			Text(title)
			Text(subtitle)
				.foregroundStyle(.secondary)
				.font(.callout)
		}
	}
}
