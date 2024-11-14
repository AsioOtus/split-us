import ComposableArchitecture
import DLModels
import ILComponents
import ILModels
import ILModelsMappers
import ILUtils
import ScreenUserGroupEditing
import ScreenUserGroupUserAdding
import ScreenUserProfile
import SwiftUI

extension UserGroupInfo {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		let userScreenModelMapper = UserScreenModel.Mapper.default

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			List {
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
			.toolbar(content: toolbar)
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
			.navigationDestination(item: $store.scope(state: \.userProfile, action: \.userProfile)) { store in
				UserProfile.Screen(store: store)
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
			elementView: usersSuccessfulView,
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

	func usersSuccessfulView (_ user: User.Compact) -> some View {
		Button {
			store.send(.onUserTap(userId: user.id))
		} label: {
			UserDetailedView(user: userScreenModelMapper.map(user))
		}
		.buttonStyle(.navigation)
	}

	func usersErrorView (_ error: Error) -> some View {
		StandardErrorView(error: error)
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

	@ToolbarContentBuilder
	func toolbar () -> some ToolbarContent {
		if let userGroupName = store.userGroup.value?.name {
			TitleSubtitleView(
				title: LocalizedStringKey(userGroupName),
				subtitle: .generalInformation
			)
			.asToolbarItem(placement: .principal)
		}

		Button {
			store.send(.onEditUserGroupButtonTap)
		} label: {
			Image(systemName: "square.and.pencil")
		}
		.asToolbarItem(placement: .topBarTrailing)
	}
}
