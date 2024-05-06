import ILModels
import SwiftUI

public struct UserNameUsernameView: View {
	let name: String?
	let surname: String?
	let username: String

	public init (
		name: String?,
		surname: String?,
		username: String
	) {
		self.name = name
		self.surname = surname
		self.username = username
	}

	public var body: some View {
		HStack {
			if name != nil || surname != nil {
				UserNameSurnameView(name: name, surname: surname)
			} else {
				UserUsernameView(username: username)
			}
		}
	}
}

#Preview {
	VStack {
		ForEach(UserInfoModel.all, id: \.username) { user in
			UserNameUsernameView(
				name: user.name,
				surname: user.surname,
				username: user.username
			)
		}
	}
}
