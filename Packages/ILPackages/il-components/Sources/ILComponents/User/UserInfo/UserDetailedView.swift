import ILModels
import SwiftUI

public struct UserDetailedView: View {
	let user: UserScreenModel

	public init (user: UserScreenModel) {
		self.user = user
	}

	public var body: some View {
		HStack {
			UserMinimalView(user: user)

			VStack(alignment: .leading) {
				if user.name?.isEmpty == false || user.surname?.isEmpty == false {
					UserNameSurnameText(name: user.name, surname: user.surname)
				}

				UserUsernameText(username: user.username)
			}
		}
	}
}

#Preview {
	VStack(alignment: .leading) {
		ForEach(UserScreenModel.all, id: \.username, content: UserDetailedView.init(user:))
	}
	.tint(.cyan)
}
