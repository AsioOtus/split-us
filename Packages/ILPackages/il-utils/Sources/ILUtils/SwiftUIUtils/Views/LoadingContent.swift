import SwiftUI

public struct LoadingContent <Content: View, Placeholder: View>: View {
	let isLoading: Bool
	let content: Content
	let placeholder: Placeholder

	public init (
		isLoading: Bool,
		@ViewBuilder content: () -> Content,
		@ViewBuilder placeholder: () -> Placeholder
	) {
		self.isLoading = isLoading
		self.content = content()
		self.placeholder = placeholder()
	}

	public var body: some View {
		contentView()
			.background {
				if isLoading {
					placeholder
				}
			}
	}

	@ViewBuilder
	private func contentView () -> some View {
		if !isLoading {
			content
		} else {
			content.hidden()
		}
	}
}
