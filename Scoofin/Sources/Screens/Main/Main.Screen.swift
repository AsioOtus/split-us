import ComposableArchitecture
import Multitool
import ScreenContactList
import ScreenSettings
import ScreenUserGroupList
import SwiftUI

extension Main {
	struct Screen: View {
		let store: StoreOf<Main.Reducer>

		var body: some View {
			TabView {
				UserGroups.Screen(store: store.scope(state: \.userGroups, action: \.userGroups))
					.tabItem {
						Label(
							.userGroupsTabName,
							systemImage: "person.2.crop.square.stack.fill"
						)
					}

				ContactsList.Screen(store: store.scope(state: \.contactsList, action: \.contactsList))
					.tabItem {
						Label(
							.contactsLinkName,
							systemImage: "person.3"
						)
					}

				Settings.Screen(store: store.scope(state: \.settings, action: \.settings))
					.tabItem {
						Label(
							.settingsTabName,
							systemImage: "slider.horizontal.3"
						)
					}
			}
		}
	}
}
