import ComposableArchitecture
import ILComponents
import SwiftUI

// MARK: - Screen
extension UserGroupEditing {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>
		
		public init (store: StoreOf<Reducer>) {
			self.store = store
		}
		
		public var body: some View {
			NavigationStack {
				contentView()
					.navigationTitle(store.userGroupName)
					.navigationBarTitleDisplayMode(.inline)
					.toolbar {
						cancelToolbarItem()
						createToolbarItem()
					}
					.task {
						store.send(.initialize)
					}
			}
		}
	}
}

// MARK: - Content view
private extension UserGroupEditing.Screen {
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
		}
	}
}

// MARK: - Subviews
private extension UserGroupEditing.Screen {
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
				label: .generalActionSave,
				loadable: store.savingUserGroupRequest
			) {
				store.send(.onSaveButtonTap, animation: .default)
			}
		}
	}
}
