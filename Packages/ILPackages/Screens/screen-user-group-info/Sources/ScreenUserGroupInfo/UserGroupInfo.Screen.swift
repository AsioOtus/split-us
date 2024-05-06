import ComposableArchitecture
import DLUtils
import ILModels
import ILModelsMappers
import ILUtils
import ScreenUserGroupEditing
import ScreenUserGroupUserAdding
import DLModels
import SwiftUI
import UnavailablePlaceholderComponents
import UserComponents

extension UserGroupInfo {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		let userInfoModelMapper = UserInfoModel.Mapper.default

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			Form {
				Section {
					userGroupNameView()
				}

				Section {
					addUserButton()
					usersView()
				} header: {
					Text(.generalUsers)
				}
			}
			.task {
				store.send(.initialize)
			}
			.toolbar {
				editUserGroupToolbarItem()
			}
			.fullScreenCover(
				item: $store.scope(state: \.userGroupEditing, action: \.userGroupEditing)
			) { store in
				UserGroupEditing.Screen(store: store)
					.transition(.opacity)
			}
			.sheet(
				item: $store.scope(state: \.userGroupUsersAdding, action: \.userGroupUsersAdding)
			) { store in
				UserGroupUsersAdding.Screen(store: store)
			}
		}
	}
}

// MARK: - User group name view
private extension UserGroupInfo.Screen {
	func userGroupNameView () -> some View {
		LoadableView(
			value: store.userGroup,
			successfulView: userGroupNameSuccessfulView
		)
	}

	func userGroupNameSuccessfulView (_ userGroup: UserGroup) -> some View {
		Text(userGroup.name)
	}
}

// MARK: - User group name view
private extension UserGroupInfo.Screen {
	func usersView () -> some View {
		LoadableElementsView(
			collection: store.users,
			loadingView: usersLoadingView,
			emptyView: usersEmptyView,
			elementView: userssuccessfulView,
			failedView: usersErrorView
		)
	}

	func usersLoadingView () -> some View {
		StandardLoadingView()
			.horizontallyCentered()
	}

	func usersEmptyView () -> some View {
		StandardEmptyView(message: .userGroupInfoUsersEmptyMessage, systemImage: "person.2.crop.square.stack")
	}

	func userssuccessfulView (_ user: User.Compact) -> some View {
		UserDetailedView(user: userInfoModelMapper.map(user))
	}

	func usersErrorView (_ error: Error) -> some View {
		StandardErrorView()
	}
}

// MARK: - Subviews
private extension UserGroupInfo.Screen {
	func addUserButton () -> some View {
		Button {
			store.send(.onAddUsersButtonTap)
		} label: {
			Label(.userGroupInfoAddUsersButtonText, systemImage: "person.fill.badge.plus")
				.labelStyle(.titleAndIcon)
		}
	}

	func editUserGroupToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			Button {
				store.send(.onEditUserGroupButtonTap)
			} label: {
				Image(systemName: "square.and.pencil")
			}
		}
	}
}
