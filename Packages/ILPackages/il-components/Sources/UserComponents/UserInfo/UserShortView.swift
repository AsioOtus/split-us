import ILModels
import SwiftUI

public struct UserShortView: View {
	let user: UserInfoModel
	
	public init (user: UserInfoModel) {
		self.user = user
	}
	
	public var body: some View {
		HStack {
			UserMinimalView(initials: user.initials, avatar: user.image)
			UserNameUsernameView(
				name: user.name,
				surname: user.surname,
				username: user.username
			)
		}
	}
}

#Preview {
	VStack {
		ForEach(UserInfoModel.all, id: \.username, content: UserShortView.init(user:))
	}
}
