import ComposableArchitecture
import DLModels
import SwiftUI

struct UserGroupView: View {
	let userGroup: UserGroup

	var store: StoreOf<UserGroups.Reducer>

	var pinButtonTitle: LocalizedStringKey {
		userGroup.isPinned ? .userGroupsActionUnpin : .userGroupsActionPin
	}

	var pinButtonIconName: String {
		userGroup.isPinned ? "pin.slash" : "pin"
	}

	var pinButtonColor: Color {
		userGroup.isPinned ? .red : .blue
	}

	var body: some View {
		Button {
			store.send(.onUserGroupSelected(userGroup))
		} label: {
			rowContentView()
		}
		.swipeActions {
			pinUserGroupButton()
		}
		.contextMenu(menuItems: contextMenuView)
	}
}

private extension UserGroupView {
	@ViewBuilder
	func contextMenuView () -> some View {
		pinUserGroupButton()
	}
}

private extension UserGroupView {

	func rowContentView () -> some View {
		HStack {
			Text(userGroup.name)

			Spacer()

			if userGroup.isPinned {
				pinMarkerView()
			}
		}
	}

	func pinMarkerView () -> some View {
		Image(systemName: "pin.fill")
			.font(.system(size: 14))
			.rotationEffect(.degrees(45))
			.foregroundStyle(.tint)
	}

	func pinUserGroupButton () -> some View {
		Button {
			store.send(.onPinButtonTapped(userGroupId: userGroup.id))
		} label: {
			Label(pinButtonTitle, systemImage: pinButtonIconName)
		}
		.tint(pinButtonColor)
	}
}
