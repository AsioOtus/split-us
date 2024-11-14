import SwiftUI

public struct BorderedTextFieldStyle: TextFieldStyle {
	public func _body (configuration: TextField<_Label>) -> some View {
		configuration
			.padding(.vertical, 2)
			.padding(.horizontal, 4)
			.background(.gray.quaternary)
			.cornerRadius(4)
	}
}

public extension TextFieldStyle where Self == BorderedTextFieldStyle {
	static var bordered: Self {
		BorderedTextFieldStyle()
	}
}

public struct BorderedViewModifier: ViewModifier {
	public func body (content: Content) -> some View {
		content
			.padding(.vertical, 2)
			.padding(.horizontal, 4)
			.background(.gray.quaternary)
			.cornerRadius(4)
	}
}

public extension View {
	func bordered () -> some View {
		modifier(BorderedViewModifier())
	}
}
