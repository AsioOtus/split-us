import ILModels
import SwiftUI

public struct UserShortView: View {
	let user: UserScreenModel
	
	public init (user: UserScreenModel) {
		self.user = user
	}
	
	public var body: some View {
		HStack(spacing: 4) {
			UserMinimalView(user: user)
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
		ForEach(UserScreenModel.all, id: \.username, content: UserShortView.init(user:))
	}
}
