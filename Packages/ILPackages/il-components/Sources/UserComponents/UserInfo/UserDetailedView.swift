import ILModels
import SwiftUI

public struct UserDetailedView: View {
	let user: UserInfoModel

	public init (user: UserInfoModel) {
		self.user = user
	}

	public var body: some View {
		HStack {
			UserMinimalView(initials: user.initials, avatar: user.image)

			VStack(alignment: .leading) {
				if user.name?.isEmpty == false || user.surname?.isEmpty == false {
					UserNameSurnameView(name: user.name, surname: user.surname)
				}

				UserUsernameView(username: user.username)
			}
		}
	}
}

#Preview {
	VStack(alignment: .leading) {
		ForEach(UserInfoModel.all, id: \.username, content: UserDetailedView.init(user:))
	}
	.tint(.cyan)
}
