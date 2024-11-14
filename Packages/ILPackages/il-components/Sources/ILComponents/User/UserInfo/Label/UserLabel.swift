import ILModels
import SwiftUI

public struct UserLabel: View {
	let userInfo: UserScreenModel

	public init (userInfo: UserScreenModel) {
		self.userInfo = userInfo
	}

	public var body: some View {
		Label(
			title: {
				UserNameUsernameText(
					name: userInfo.name,
					surname: userInfo.surname,
					username: userInfo.username
				)
			},
			icon: {
				UserImage(userInfo: userInfo)
			}
		)
	}
}
