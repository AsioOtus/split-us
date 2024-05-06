import ILModels
import SwiftUI

public struct UserMinimalView: View {
	let initials: String
	let avatar: Image?

	public init (
		initials: String,
		avatar: Image?
	) {
		self.initials = initials
		self.avatar = avatar
	}

	public var body: some View {
		if let avatar {
			UserAvatarView(image: avatar)
		} else {
			UserInitialsView(initials: initials)
		}
	}
}

public extension UserMinimalView {
	init (user: UserInfoModel) {
		self.init(initials: user.initials, avatar: user.image)
	}
}

#Preview {
	VStack {
		UserMinimalView(initials: "AB", avatar: .init(systemName: "person.fill"))
		UserMinimalView(initials: "AB", avatar: nil)
	}
}
