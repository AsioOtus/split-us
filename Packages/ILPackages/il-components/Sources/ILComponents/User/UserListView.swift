import SwiftUI
import ILModels

public struct UserListView: View {
	let users: [UserScreenModel]
	@Binding var selectedUsers: Set<UserScreenModel>
	
	public init (
		users: [UserScreenModel],
		selectedUsers: Binding<Set<UserScreenModel>>
	) {
		self.users = users
		self._selectedUsers = selectedUsers
	}
	
	public var body: some View {
		List(users, id: \.self) { user in
			RowView(user: user, isSelected: selectedUsers.contains(user)) {
				if selectedUsers.contains(user) {
					selectedUsers.remove(user)
				} else {
					selectedUsers.insert(user)
				}
			}
		}
	}
}

extension UserListView {
	struct RowView: View {
		let user: UserScreenModel
		let isSelected: Bool
		let onSelected: () -> Void
		
		var body: some View {
			Button(action: onSelected) {
				UserShortView(user: user)
			}
			.listRowBackground(isSelected ? Color(red: 0.9, green: 0.9, blue: 1, opacity: 1) : nil)
		}
	}
}
