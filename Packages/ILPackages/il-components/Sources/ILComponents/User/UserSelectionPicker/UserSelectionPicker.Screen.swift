import DLModels
import DLModelsSamples
import ILLocalization
import ILModels
import ILModelsMappers
import SwiftUI

public struct UserSelectionPicker: View {
	private let userScreenModelMapper = UserScreenModel.Mapper.default

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
	@ViewBuilder @MainActor
	func userView (_ user: User.Compact?) -> some View {
		if let user {
			UserLabel(userInfo: userScreenModelMapper.map(user))
		} else {
			Text(.generalNotSelected)
			Divider()
		}
	}

	@ViewBuilder
	func selectedUserView () -> some View {
		if let selectedUser {
			UserShortView(user: userScreenModelMapper.map(selectedUser))
		} else {
			Text(.generalNotSelected)
		}
	}
}

#Preview {
	UserSelectionPicker(
		users: [
			.sampleA,
			.sampleB
		],
		selectedUser: .constant(nil)
	)
}
