import ComponentsTCAUser
import ComposableArchitecture
import DLModels
import DLServices
import ILComponents
import ILModels
import ILUtils
import ScreenAddContacts
import ScreenUserProfile
import SwiftUI

extension ContactsList {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>
		let userScreenModelMapper = UserScreenModel.Mapper.default

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
					.sheet(
						item: $store.scope(state: \.addContact, action: \.addContact)
					) { store in
						AddContacts.Screen(store: store)
					}
					.navigationDestination(
						item: $store.scope(state: \.contactDetails, action: \.contactDetails)
					) { store in
						UserProfile.Screen(store: store)
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
		.listStyle(.inset)
	}

	func loadingView () -> some View {
		StandardLoadingView()
	}

	func emptyView () -> some View {
		StandardEmptyView(message: .contactsEmptyMessage, systemImage: "person.3")
	}

	func successfulView (_ contacts: [User.Compact]) -> some View {
		ForEach(contacts, id: \.id) { contact in
			contactView(contact)
		}
	}

	func failedView (_ error: Error) -> some View {
		StandardErrorView(error: error) {
			RetryButton {
				store.send(.refresh)
			}
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
		Button {
			store.send(.onContactTap(userId: contact.id))
		} label: {
			UserDetailedView(user: userScreenModelMapper.map(contact))
				.contentShape(.rect)
		}
		.buttonStyle(.plain)
		.swipeActions(edge: .leading) {
			AddRemoveContactButton.Screen(
				store: .init(
					initialState: .init(
						userId: contact.id,
						isContact: true
					),
					reducer: {
						AddRemoveContactButton.Reducer()
					}
				)
			)
		}
	}
}
