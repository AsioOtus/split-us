import ILModels
import ILUtils
import SwiftUI

public struct UserMinimalView: View {
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
		if avatar == nil && acronym.isEmpty {
			Self.default()
		} else {
			AvatarView(
				avatar: avatar,
				acronym: acronym,
				color: color
			)
		}
	}
}

public extension UserMinimalView {
	init (user: UserScreenModel) {
		self.init(
			avatar: user.image,
			acronym: user.initials,
			color: user.color.color
		)
	}
}

public extension UserMinimalView {
	static func unknown () -> some View {
		AcronymView(
			acronym: Text(Image(systemName: "questionmark")),
			background: .background.shadow(.inner(color: .secondary, radius: 10)),
			foreground: .foreground,
			stroke: .background.secondary
		)
	}

	static func `default` () -> some View {
		AcronymView(
			acronym: Text(Image(systemName: "person.fill")),
			background: .background.shadow(.inner(color: .secondary, radius: 10)),
			foreground: .foreground,
			stroke: .background.secondary
		)
	}
}

#Preview(traits: .sizeThatFitsLayout) {
	VStack {
		UserMinimalView(avatar: .init(systemName: "person.fill"), acronym: "AB", color: .blue)
		UserMinimalView(avatar: nil, acronym: "AB", color: .green)
			.avatarSize(.extraLarge)

		UserMinimalView.unknown()
		UserMinimalView.default()
	}
	.avatarSize(.large)
}
