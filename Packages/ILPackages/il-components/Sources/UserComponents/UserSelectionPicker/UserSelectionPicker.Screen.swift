import ILLocalization
import DLModels
import SwiftUI
import ILModels
import ILModelsMappers

public struct UserSelectionPicker: View {
	private let userInfoModelMapper = UserInfoModel.Mapper.default
	
	let users: [User.Compact?]
	@Binding var selectedUser: User.Compact?
	
	public init (
		users: [User.Compact?],
		selectedUser: Binding<User.Compact?>
	) {
		self.users = users
		self._selectedUser = selectedUser
	}
	
	public var body: some View {
		HStack {
			Menu {
				Picker("", selection: $selectedUser) {
					ForEach(users, id: \.self) { user in
						userView(user)
					}
				}
				.labelsHidden()
			} label: {
				selectedUserView()
			}
		}
	}
}

private extension UserSelectionPicker {
	@ViewBuilder
	func userView (_ user: User.Compact?) -> some View {
		if let user {
			UserNameUsernameText(
				name: user.name,
				surname: user.surname,
				username: user.username
			)
		} else {
			Text(.userSelectionPickerNotSelected)
			Divider()
		}
	}
	
	@ViewBuilder
	func selectedUserView () -> some View {
		if let selectedUser {
			UserShortView(user: userInfoModelMapper.map(selectedUser))
		} else {
			Text(.userSelectionPickerNotSelected)
		}
	}
}
