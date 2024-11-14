import ILModels
import SwiftUI

public struct UserProfileView: View {
	let user: CurrentUserScreenModel
	
	public init (user: CurrentUserScreenModel) {
		self.user = user
	}
	
	public var body: some View {
		HStack {
			UserMinimalView(avatar: user.image, acronym: user.initials, color: user.color)
			
			VStack(alignment: .leading) {
				if user.name != nil || user.surname != nil {
					UserNameSurnameText(name: user.name, surname: user.surname)
				}
				
				UserUsernameText(username: user.username)

				if let email = user.email {
					EmailView(email: email)
						.foregroundStyle(.secondary)
				}
			}
		}
	}
	
	func credentialsView () -> some View {
		HStack(spacing: 4) {
			UserUsernameText(username: user.username)
			
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
		ForEach(CurrentUserScreenModel.all, id: \.username, content: UserProfileView.init(user:))
	}
	.tint(.cyan)
}
