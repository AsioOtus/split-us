import ComponentsTCAUser
import ComposableArchitecture
import DLModels
import ILComponents
import ILModels
import ILModelsMappers
import ILUtils
import SwiftUI

extension AddContacts {
	public struct Screen: View {
		@SwiftUI.State private var isSearchFieldPresented = true

		@Bindable var store: StoreOf<Reducer>
		let userScreenModelMapper = UserScreenModel.Mapper.default
		
		public init (store: StoreOf<Reducer>) {
			self.store = store
		}
		
		public var body: some View {
			NavigationStack {
				contentView()
					.disabled(store.searchResult.isLoading)
					.navigationTitle(.addContactsTitle)
					.navigationBarTitleDisplayMode(.inline)
					.toolbar {
						closeToolbarItem()
					}
					.searchable(
						text: $store.username,
						isPresented: $isSearchFieldPresented,
						placement: .navigationBarDrawer(displayMode: .always)
					)
					.autocapitalization(.none)
					.submitLabel(.search)
					.onSubmit(of: .search) {
						store.send(.onSearchButtonTap)
					}
					.scrollDismissesKeyboard(.immediately)
					.task {
						store.send(.initialize)
					}
			}
		}
	}
}

private extension AddContacts.Screen {
	@MainActor
	func contentView () -> some View {
		Form {
			searchResultView()
		}
	}
	
	@ViewBuilder
	func searchResultView () -> some View {
		LoadableOptionalView(
			value: store.searchResult,
			initialView: {
				EmptyView()
			},
			loadingView: {
				EmptyView()
			},
			someView: { user in
				loadedSomeView(user)
			},
			noneView: {
				loadedNoneView()
			},
			failedView: { error in
				errorView(error)
			}
		)
	}

	@ViewBuilder
	func loadedSomeView (_ contact: User.Contact) -> some View {
		Section {
			UserDetailedView(user: userScreenModelMapper.map(contact.user))
				.avatarSize(.large)
		}

		Section {
			AddRemoveContactButton.Screen(
				store: .init(
					initialState: .init(
						userId: contact.user.id,
						isContact: contact.isContact
					),
					reducer: {
						AddRemoveContactButton.Reducer()
					}
				)
			)
			.frame(maxWidth: .infinity)
		}
	}

	func loadedNoneView () -> some View {
		StandardEmptyView(message: .generalNothingFound, systemImage: "magnifyingglass")
	}
	
	func errorView (_ error: Error) -> some View {
		StandardErrorView(error: error)
	}

	func closeToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {
			Button(.generalActionClose) {
				store.send(.onCancelButtonTap)
			}
		}
	}
}
