import ILUtils
import SwiftUI

public struct DismissKeyboardButton <Content: View>: View {
	let content: Content

	public init (
		@ViewBuilder content: () -> Content
	) {
		self.content = content()
	}

	public init () where Content == DismissKeyboardLabel  {
		self.content = DismissKeyboardLabel()
	}

	public init (text: LocalizedStringKey) where Content == DismissKeyboardLabel  {
		self.content = DismissKeyboardLabel(text: text)
	}

	public var body: some View {
		Button {
			KeyboardUtil.dismissKeyboard()
		} label: {
			content
		}
		.fontWeight(.medium)
	}
}
