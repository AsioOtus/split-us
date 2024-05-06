import ILLocalization
import ILUtils
import ILPreview
import SwiftUI

public struct StandardErrorView: View {
	@Environment(\.controlSize) private var controlSize

	public init () { }

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
		HStack(alignment: .firstTextBaseline) {
			Image(systemName: "exclamationmark.octagon")
				.foregroundStyle(.red.secondary)

			Text(.generalShortSomethingWentWrong)
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
		}
	}
}

#Preview {
	PreviewCollection(ControlSize.allCases) {
		StandardErrorView()
			.controlSize($0)
	}
}
