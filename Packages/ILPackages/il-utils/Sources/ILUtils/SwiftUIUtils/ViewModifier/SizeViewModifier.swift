import SwiftUI

struct SizeViewModifier: ViewModifier {
	struct SizePreferenceKey: PreferenceKey {
		static var defaultValue: CGSize?

		static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
			value = nextValue()
		}
	}

	@Binding var size: CGSize?

	func body (content: Content) -> some View {
		content
			.background {
				GeometryReader { g in
					Color.clear
						.preference(key: SizePreferenceKey.self, value: g.size)
				}
				.onPreferenceChange(SizePreferenceKey.self) { value in
					size = value
				}
			}
	}
}

public extension View {
	func size (_ size: Binding<CGSize?>) -> some View {
		modifier(SizeViewModifier(size: size))
	}
}
