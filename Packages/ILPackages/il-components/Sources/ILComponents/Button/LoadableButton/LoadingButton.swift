import ILUtils
import SwiftUI

public struct LoadingButton <Content: View, Placeholder: View>: View {
	let isLoading: Bool
	let action: () -> Void
	let content: Content
	let placeholder: Placeholder

	public init (
		isLoading: Bool,
		action: @escaping () -> Void,
		@ViewBuilder content: () -> Content
	) where Placeholder == StandardLoadingView {
		self.isLoading = isLoading
		self.action = action
		self.content = content()
		self.placeholder = .init()
	}

	public init (
		isLoading: Bool,
		action: @escaping () -> Void,
		@ViewBuilder content: () -> Content,
		@ViewBuilder placeholder: () -> Placeholder
	) {
		self.isLoading = isLoading
		self.action = action
		self.content = content()
		self.placeholder = placeholder()
	}

	public var body: some View {
		Button(action: action) {
			LoadingContent(isLoading: isLoading) {
				content
			} placeholder: {
				placeholder
			}
		}
	}
}
