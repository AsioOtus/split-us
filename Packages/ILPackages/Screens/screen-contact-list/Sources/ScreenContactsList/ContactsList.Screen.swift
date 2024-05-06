import ButtonComponents
import ComposableArchitecture
import DLServices
import DLUtils
import ILModels
import ILUtils
import ScreenAddContacts
import ScreenUserDetails
import DLModels
import SwiftUI
import UnavailablePlaceholderComponents
import UserComponents

extension ContactsList {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>
		let userInfoModelMapper = UserInfoModel.Mapper.default
		
		public init (store: StoreOf<Reducer>) {
			self.store = store
		}
		
		public var body: some View {
			NavigationStack {
				contentView()
					.navigationTitle(.contactsTitle)
					.toolbar {
						addContactToolbarItem()
					}
					.task {
						store.send(.initialize)
					}
					.refreshable {
						await store.send(.refresh).finish()
					}
					.navigationDestination(
						item: $store.scope(state: \.contactDetails, action: \.contactDetails)
					) { store in
						UserDetails.Screen(store: store)
					}
			}
		}
	}
}

private extension ContactsList.Screen {
	func contentView () -> some View {
		LoadableList(
			collection: store.contacts,
			loadingView: loadingView,
			emptyView: emptyView,
			successfulView: successfulView,
			failedView: failedView
		)
	}
	
	func loadingView () -> some View {
		StandardLoadingView()
	}
	
	func emptyView () -> some View {
		StandardEmptyView(message: .contactsEmptyMessage, systemImage: "person.3")
	}
	
	func successfulView (_ contacts: [User.Compact]) -> some View {
		ForEach(contacts, id: \.id) { contact in
			NavigationLink(state: UserDetails.State(userId: contact.id)) {
				contactView(contact)
			}
		}
	}
	
	func failedView (_ error: Error) -> some View {
		StandardRetryErrorView {
			store.send(.refresh)
		}
	}
	
	func addContactToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			Button {
				store.send(.onAddContactScreenButtonTap)
			} label: {
				Image(systemName: "plus")
			}
		}
	}
}

// MARK: - Subviews
private extension ContactsList.Screen {
	func contactView (_ contact: User.Compact) -> some View {
		UserDetailedView(user: userInfoModelMapper.map(contact))
			.controlSize(.regular)
			.swipeActions(edge: .leading) {
				AddRemoveContactButton(
					isContact: true,
					processingState: .initial(),
					addAction: { },
					removeAction: { store.send(.onRemoveContactButtonTap(userId: contact.id)) }
				)
			}
	}
}
