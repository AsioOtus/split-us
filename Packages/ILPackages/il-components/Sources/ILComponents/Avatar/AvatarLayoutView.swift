import SwiftUI

public struct AvatarLayoutView <
	Content: View,
	Background: ShapeStyle,
	Foreground: ShapeStyle,
	Stroke: ShapeStyle
>: View {
	@Environment(\.avatarSize) private var avatarSize

	private let content: Content
	private let background: Background
	private let foreground: Foreground
	private let stroke: Stroke
	private let strokeWidth: Double

	public init (
		background: Background,
		foreground: Foreground,
		stroke: Stroke,
		strokeWidth: Double = 1,
		content: () -> Content
	) {
		self.content = content()
		self.background = background
		self.foreground = foreground
		self.stroke = stroke
		self.strokeWidth = strokeWidth
	}

	public var body: some View {
		GeometryReader { g in
			content
				.font(.system(size: g.size.width * 0.5, weight: .medium, design: .rounded))
				.minimumScaleFactor(0.5)
				.lineLimit(1)
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
		}
		.background {
			Circle()
				.fill(background)
		}
		.foregroundStyle(foreground)
		.frame(width: avatarSize.value, height: avatarSize.value)
		.clipShape(.circle)
		.overlay {
			Circle()
				.stroke(stroke, lineWidth: strokeWidth)
		}
	}
}

#Preview {
	VStack {
		AvatarLayoutView(
			background: .red.shadow(.inner(radius: 10)),
			foreground: .background,
			stroke: .red.quaternary
		) {
			Text("AB")
		}

		AvatarLayoutView(
			background: .background,
			foreground: .foreground,
			stroke: .tertiary
		) {
			Image(systemName: "person.fill")
		}

		AvatarLayoutView(
			background: .background,
			foreground: .foreground,
			stroke: .tertiary
		) {
			Image(systemName: "person.fill")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.padding()
		}

		AvatarLayoutView(
			background: .background,
			foreground: .foreground,
			stroke: .quaternary
		) {
			Text(Image(systemName: "questionmark"))
		}

		AvatarLayoutView(
			background: .clear,
			foreground: .background,
			stroke: .quaternary
		) {
			AsyncImage(url: URL(string: "https://innostudio.de/fileuploader/images/default-avatar.png")!) {
				$0
					.resizable()
			} placeholder: {
				ProgressView()
					.controlSize(.mini)
			}
		}
	}
	.avatarSize(.large)
}
