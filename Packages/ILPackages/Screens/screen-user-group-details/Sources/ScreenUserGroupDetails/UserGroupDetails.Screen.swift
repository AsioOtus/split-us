import ComposableArchitecture
import Dependencies
import ScreenSummary
import ScreenTransferList
import ScreenUserGroupInfo
import DLServices
import SwiftUI

extension UserGroupDetails {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			transferListView()
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					titleToolbarItem()
					summaryToolbarItem()
					userGroupInfoToolbarItem()
				}
				.navigationDestination(
					item: $store.scope(state: \.summary, action: \.summary)
				) { store in
					Summary.Screen(store: store)
				}
				.navigationDestination(
					item: $store.scope(state: \.userGroupInfo, action: \.userGroupInfo)
				) { store in
					UserGroupInfo.Screen(store: store)
				}
		}
	}
}

private extension UserGroupDetails.Screen {
	func transferListView () -> some View {
		TransferList.Screen(
			store: store.scope(state: \.transferList, action: \.transferList)
		)
	}
}

private extension UserGroupDetails.Screen {
	func titleToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .principal) {
			Button(store.userGroup.name) {
				store.send(.onTitleTap)
			}
			.buttonStyle(.plain)
		}
	}

	func summaryToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			Button {
				store.send(.onSummaryButtonTap)
			} label: {
				Image(systemName: "sum")
			}
		}
	}

	func userGroupInfoToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			Button {
				store.send(.onInfoButtonTap)
			} label: {
				Image(systemName: "chevron.forward.circle")
			}
		}
	}
}
