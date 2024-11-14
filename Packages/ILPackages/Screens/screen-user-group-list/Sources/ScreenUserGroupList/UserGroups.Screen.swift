import ComponentsTCAGeneral
import ComposableArchitecture
import DLModels
import DLServices
import ILComponents
import ILUtils
import ILUtilsTCA
import ScreenUserGroupCreation
import ScreenUserGroupDetails
import SwiftUI

extension UserGroups {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			NavigationStack {
				contentView()
					.task { store.send(.initialize) }
					.refreshable { await store.send(.refresh).finish() }
					.navigationTitle(.userGroupsGroups)
					.toolbar {
						createUserGroupToolbarItem()
					}
					.sheet(item: $store.scope(state: \.creation, action: \.creation)) { store in
						UserGroupCreation.Screen(store: store)
					}
					.navigationDestination(
						item: $store.scope(state: \.userGroupDetails, action: \.userGroupDetails)
					) { store in
						UserGroupDetails.Screen(store: store)
					}
			}
		}
	}
}

private extension UserGroups.Screen {
	func contentView () -> some View {
		List {
			Section {
				ConnectionStateFeature.RegularScreen(
					store: store.scope(
						state: \.userGroups.connectionState,
						action: \.userGroups.connectionState
					)
				)
			}

			Section {
				PageLoading<UserGroup>.Screen(
					store: store.scope(
						state: \.userGroups,
						action: \.userGroups
					)
				) { userGroupPageItem in
					UserGroupView(userGroup: userGroupPageItem.item, store: store)
				}
			}
		}
		.listStyle(.plain)
	}
}

private extension UserGroups.Screen {
	func createUserGroupToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			Button {
				store.send(.onCreateButtonTap)
			} label: {
				Image(systemName: "plus")
			}
		}
	}
}
