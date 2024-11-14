import SwiftUI

public struct AvatarImageView: View {
	let image: Image

	public init (image: Image) {
		self.image = image
	}

	public var body: some View {
		AvatarLayoutView(
			background: .background,
			foreground: .foreground,
			stroke: .foreground.tertiary
		) {
			image
				.resizable()
				.aspectRatio(contentMode: .fit)
		}
	}
}

#Preview(traits: .sizeThatFitsLayout) {
	VStack {
		ForEach(AvatarSize.allCases, id: \.self) {
			AvatarImageView(image: .init(systemName: "person.fill"))
				.avatarSize($0)
		}
	}
}
