import ComposableArchitecture
import DLServices
import DLUtils
import ILUtils
import ScreenUserGroupCreation
import ScreenUserGroupDetails
import DLModels
import SwiftUI
import UnavailablePlaceholderComponents

extension UserGroups {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			NavigationStack {
				contentView()
					.navigationTitle(.userGroupsGroups)
					.toolbar {
						createUserGroupToolbarItem()
					}
					.refreshable {
						await store.send(.refresh).finish()
					}
					.sheet(item: $store.scope(state: \.creation, action: \.creation)) { store in
						UserGroupCreation.Screen(store: store)
					}
					.navigationDestination(
						item: $store.scope(state: \.userGroupDetails, action: \.userGroupDetails)
					) { store in
						UserGroupDetails.Screen(store: store)
					}
					.task {
						store.send(.initialize)
					}
			}
		}
	}
}

private extension UserGroups.Screen {
	func contentView () -> some View {
		LoadableList(
			collection: store.userGroups,
			loadingView: loadingView,
			emptyView: emptyView,
			successfulView: { successfulView($0, store.currentUser) },
			failedView: failedView
		)
		.listStyle(.plain)
	}

	func loadingView () -> some View {
		StandardLoadingView()
	}

	func emptyView () -> some View {
		StandardEmptyView(
			message: .userGroupsEmptyMessage,
			systemImage: "person.2.crop.square.stack"
		)
	}

	func successfulView (_ userGroups: [UserGroup], _ currentUser: User) -> some View {
		ForEach(userGroups, id: \.id) { userGroup in
			Button(userGroup.name) {
				store.send(.onUserGroupSelected(userGroup))
			}
		}
	}

	func failedView (_ error: Error? = nil) -> some View {
		StandardRetryErrorView {
			store.send(.refresh)
		}
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
