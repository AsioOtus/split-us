import SwiftUI

public struct NavigationButtonStyle: ButtonStyle {
	public func makeBody (configuration: Configuration) -> some View {
		configuration
			.label
			.badge(DetailsIndicator.text())
			.frame(maxWidth: .infinity, alignment: .leading)
			.contentShape(.rect)
	}
}

public extension ButtonStyle where Self == NavigationButtonStyle {
	static var navigation: NavigationButtonStyle { .init() }
}

#Preview {
	NavigationStack {
		List {
			NavigationLink(
				destination: { Text("") },
				label: { Label("Title", systemImage: "person") }
			)

			Button {
				print("Action 2")
			} label: {
				Label("Title", systemImage: "person")
			}
			.buttonStyle(.navigation)
		}
		.listStyle(.grouped)
	}
}
