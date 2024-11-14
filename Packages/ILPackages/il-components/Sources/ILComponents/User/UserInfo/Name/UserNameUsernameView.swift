import ILModels
import ILPreviewModels
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
		if name != nil || surname != nil {
			UserNameSurnameText(name: name, surname: surname)
		} else {
			UserUsernameText(username: username)
		}
	}
}

#Preview {
	VStack {
		ForEach(UserScreenModel.all, id: \.username) { user in
			UserNameUsernameView(
				name: user.name,
				surname: user.surname,
				username: user.username
			)
		}
	}
}
