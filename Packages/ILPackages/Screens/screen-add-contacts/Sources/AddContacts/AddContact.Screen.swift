import ButtonComponents
import ComposableArchitecture
import DLUtils
import ILModels
import ILModelsMappers
import ILComponentsViewModifiers
import ILUtils
import DLModels
import SwiftUI
import UnavailablePlaceholderComponents
import UserComponents

extension AddContacts {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>
		let userInfoModelMapper = UserInfoModel.Mapper.default
		
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
					.submitLabel(.done)
					.onSubmit {
						store.send(.onSearchButtonTap)
					}
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
			Section {
				usernameField()
				searchButton()
			}
			
			Section {
				searchResultView()
			}
		}
	}
	
	@MainActor
	func usernameField () -> some View {
		TextField(.generalUsername, text: $store.username)
			.usernameField()
	}
	
	func searchButton () -> some View {
		LoadableButton(label: .generalActionSearch, loadable: store.searchResult) {
			store.send(.onSearchButtonTap)
		}
		.frame(maxWidth: .infinity, alignment: .center)
	}
	
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
			failedView: { _ in
				errorView()
			}
		)
	}
	
	func loadedSomeView (_ result: User.ContactSearch) -> some View {
		HStack {
			UserDetailedView(user: userInfoModelMapper.map(result.user))
				.controlSize(.regular)
			
			Spacer()
			
			AddRemoveContactButton(
				isContact: result.isContact,
				processingState: store.addRemoveRequest,
				addAction: {
					store.send(.onAddContactsButtonTap(userId: result.user.id))
				},
				removeAction: {
					store.send(.onRemoveContactButtonTap(userId: result.user.id))
				}
			)
		}
	}
	
	func loadedNoneView () -> some View {
		StandardEmptyView(message: .generalNothingFound, systemImage: "magnifyingglass")
	}
	
	func errorView () -> some View {
		StandardErrorView()
	}
	
	func closeToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {
			Button(.generalActionClose) {
				store.send(.onCancelButtonTap)
			}
		}
	}
}
