import ILUtils
import ILPreview
import SwiftUI

public struct StandardRetryErrorView: View {
	@Environment(\.controlSize) private var controlSize

	let retryAction: () -> Void

	public init (retryAction: @escaping () -> Void) {
		self.retryAction = retryAction
	}

	public var body: some View {
		switch controlSize {
		case .mini:
			miniView()
		case .small:
			regularView()
		case .regular:
			regularView()
		case .large:
			regularView()
		case .extraLarge:
			regularView()
		@unknown default:
			regularView()
		}
	}

	func miniView () -> some View {
		HStack {
			Image(systemName: "exclamationmark.octagon")
				.foregroundStyle(.red.secondary)

			Button(.generalActionRefresh, action: retryAction)
				.buttonStyle(.bordered)
				.buttonBorderShape(.capsule)
		}
	}

	func regularView () -> some View {
		ContentUnavailableView {
			Label {
				Text(.generalSomethingWentWrong)
			} icon: {
				Image(systemName: "exclamationmark.octagon")
					.foregroundStyle(.red.secondary)
			}
		} description: {
			Text("")
		} actions: {
			Button(.generalActionRefresh, action: retryAction)
				.buttonStyle(.bordered)
				.buttonBorderShape(.roundedRectangle)
		}
	}
}

#Preview {
	PreviewCollection(ControlSize.allCases) {
		StandardRetryErrorView(retryAction: { })
			.controlSize($0)
	}
}
