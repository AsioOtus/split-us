import ILModels
import SwiftUI

public struct UserProfileView: View {
	let user: CurrentUserInfoModel
	
	public init (user: CurrentUserInfoModel) {
		self.user = user
	}
	
	public var body: some View {
		HStack {
			UserMinimalView(initials: user.initials, avatar: user.image)
			
			VStack(alignment: .leading) {
				if user.name != nil || user.surname != nil {
					UserNameSurnameView(name: user.name, surname: user.surname)
				}
				
				UserUsernameView(username: user.username)
				
				if let email = user.email {
					EmailView(email: email)
						.foregroundStyle(.secondary)
				}
			}
		}
	}
	
	func credentialsView () -> some View {
		HStack(spacing: 4) {
			UserUsernameView(username: user.username)
			
			if let email = user.email {
				Text("•")
				EmailView(email: email)
			}
		}
		.foregroundStyle(.secondary)
	}
}

#Preview {
	VStack(alignment: .leading) {
		ForEach(CurrentUserInfoModel.all, id: \.username, content: UserProfileView.init(user:))
	}
	.tint(.cyan)
}
