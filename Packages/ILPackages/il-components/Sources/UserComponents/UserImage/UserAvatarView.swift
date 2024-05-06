import SwiftUI

public struct UserAvatarView: View {
	@Environment(\.controlSize) private var controlSize
	
	let image: Image
	
	public init (image: Image) {
		self.image = image
	}
	
	public var body: some View {
		Capsule()
			.stroke(.secondary, lineWidth: 1)
			.overlay {
				image
					.resizable()
					.clipShape(.circle)
			}
			.frame(width: controlSize.userImageSize, height: controlSize.userImageSize)
	}
}

#Preview {
	UserAvatarView(image: .init(systemName: "person.fill"))
}
