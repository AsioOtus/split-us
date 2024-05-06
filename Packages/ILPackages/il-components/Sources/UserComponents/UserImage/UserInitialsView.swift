import SwiftUI
import DLUtils

public struct UserInitialsView: View {
	@Environment(\.controlSize) private var controlSize

	let initials: String

	public init (initials: String) {
		self.initials = initials
	}

	public var body: some View {
		Capsule()
			.stroke(.secondary, lineWidth: 1)
			.fill(.ultraThinMaterial)
			.frame(width: controlSize.userImageSize, height: controlSize.userImageSize)
			.overlay {
				Text(initials)
					.font(.system(size: 20))
					.padding(4)
					.minimumScaleFactor(0.5)
					.foregroundStyle(.primary)
			}
	}
}

#Preview {
	ZStack {
		let initials = [
			"a",
			"ab",
			"A",
			"AB",
		]

		Color.black.opacity(0.2)

		HStack {
			ForEach(initials, id: \.self) { initials in
				VStack {
					ForEach(ControlSize.allCases, id: \.self) { size in
						UserInitialsView(initials: initials)
							.controlSize(size)
					}
				}
			}
		}
	}
}
