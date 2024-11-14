import ComponentsTCAUser
import ComposableArchitecture
import ILComponents
import ILUtilsTCA
import SwiftUI

extension UserGroupCreation {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			NavigationStack {
				contentView()
					.navigationTitle(.userGroupCreationTitle)
					.navigationBarTitleDisplayMode(.inline)
					.toolbar {
						cancelToolbarItem()
						createToolbarItem()
					}
			}
			.onAppear {
				store.send(.initialize)
			}
		}
	}
}

private extension UserGroupCreation.Screen {
	@MainActor
	func contentView () -> some View {
		Form {
			Section {
				TextField(.generalName, text: $store.userGroupName.animation())
			} footer: {
				if store.isUserGroupNameValidationRequired, store.userGroupName.isEmpty {
					InlineErrorMessageView(message: .userGroupCreationUserGroupNameWarningEmpty)
				}
			}

			ComposableLoadableView(
				store: store.scope(state: \.contactsSelection, action: \.contactsSelection),
				loadingView: loadingView,
				successfulView: successfulView,
				failedView: failedView
			)
		}
	}

	func loadingView () -> some View {
		Section {
			StandardLoadingView()
				.frame(maxWidth: .infinity, alignment: .center)
		}
	}

	func successfulView (_ store: StoreOf<UserEjectSelection.Reducer>) -> some View {
		UserEjectSelection.Screen(store: store)
			.controlSize(.small)
	}

	func failedView (_ error: Error) -> some View {
		Section {
			StandardErrorView(error: error)
		}
	}
}

private extension UserGroupCreation.Screen {
	func cancelToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {
			Button(.generalActionCancel) {
				store.send(.onCancelButtonTap)
			}
		}
	}

	func createToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .topBarTrailing) {
			LoadableButton(
				label: .generalActionCreate,
				loadable: store.createUserGroupRequest
			) {
				store.send(.onCreateButtonTap, animation: .default)
			}
		}
	}
}
