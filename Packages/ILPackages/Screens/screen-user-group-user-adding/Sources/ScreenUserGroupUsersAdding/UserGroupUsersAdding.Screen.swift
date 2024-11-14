import ComponentsTCAUser
import ComposableArchitecture
import ILComponents
import ILUtilsTCA
import SwiftUI

// MARK: - Screen
extension UserGroupUsersAdding {
	public struct Screen: View {
		let store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			NavigationStack {
				contentView()
					.toolbar {
						cancelToolbarItem()
						addToolbarItem()
					}
			}
			.task {
				store.send(.initialize)
			}
		}
	}
}

// MARK: - Content view
private extension UserGroupUsersAdding.Screen {
	func contentView () -> some View {
		Form {
			ComposableLoadableView(
				store: store.scope(state: \.contactsSelection, action: \.contactsSelection),
				initialView: { failedView() },
				loadingView: loadingView,
				successfulView: successfulView,
				failedView: failedView
			)
		}
	}

	func loadingView () -> some View {
		StandardLoadingView()
			.horizontallyCentered()
	}

	func emptyView () -> some View {
		StandardEmptyView(message: .contactsEmptyMessage, systemImage: "person.3")
	}

	func successfulView (_ store: StoreOf<UserEjectSelection.Reducer>) -> some View {
		UserEjectSelection.Screen(store: store)
			.controlSize(.small)
	}

	@ViewBuilder
	func failedView (_ error: Error? = nil) -> some View {
		if let error {
			StandardErrorView(error: error) {
				RetryButton {
					store.send(.refresh)
				}
			}
		}
	}
}

// MARK: - Subviews
private extension UserGroupUsersAdding.Screen {
	func addToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .topBarTrailing) {
			LoadableButton(label: .generalActionAdd, loadable: store.usersAddingRequest) {
				store.send(.onAddButtonTap)
			}
		}
	}

	func cancelToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {
			Button(.generalActionCancel) {
				store.send(.onCancelButtonTap)
			}
		}
	}
}
