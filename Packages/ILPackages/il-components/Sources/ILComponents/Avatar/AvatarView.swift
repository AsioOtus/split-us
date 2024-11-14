import SwiftUI

public struct AvatarView: View {
	public static func animationId (_ userId: String, _ orderId: String?) -> String {
		let id = ["AvatarView-animationId", userId, orderId]
			.compactMap { $0 }
			.joined(separator: "-")

		return id
	}

	@Namespace private var animationNamespace
	@Environment(\.avatarAnimationNamespace) private var avatarAnimationNamespace
	@Environment(\.avatarOrderIdentifier) private var avatarOrderIdentifier

	let avatar: Image?
	let acronym: String
	let color: Color

	public init (
		avatar: Image?,
		acronym: String,
		color: Color
	) {
		self.avatar = avatar
		self.acronym = acronym
		self.color = color
	}

	public var body: some View {
		if let avatar {
			AvatarImageView(image: avatar)
				.matchedGeometryEffect(
					id: Self.animationId(acronym, avatarOrderIdentifier),
					in: avatarAnimationNamespace ?? animationNamespace
				)
		} else {
			AcronymView(
				acronym: acronym,
				background: color.shadow(.inner(color: .black.opacity(0.5), radius: 10)),
				stroke: color.secondary
			)
			.matchedGeometryEffect(
				id: Self.animationId(acronym, avatarOrderIdentifier),
				in: avatarAnimationNamespace ?? animationNamespace
			)
		}
	}
}

#Preview {
	VStack {
		AvatarView(
			avatar: nil,
			acronym: "AC",
			color: .red
		)

		AvatarView(
			avatar: .init(systemName: "person.fill"),
			acronym: "AC",
			color: .red
		)
	}
	.avatarSize(.extraLarge)
}
