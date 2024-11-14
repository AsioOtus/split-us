import ComposableArchitecture
import DLModels
import SwiftUI

extension SingleSelector {
	public struct ScreenList <ItemView: View>: View {
		let store: StoreOf<Reducer>
		let itemView: (Item) -> ItemView

		public init (store: StoreOf<Reducer>, itemView: @escaping (Item) -> ItemView) {
			self.store = store
			self.itemView = itemView
		}

		public var body: some View {
			List {
				Section {
					ConnectionStateFeature.RegularScreen(
						store: store.scope(
							state: \.pageLoading.connectionState,
							action: \.pageLoading.connectionState
						)
					)
				}

				Section {
					notSelectedView()
				}

				Section {
					PageLoading<Item>.Screen(
						store: store.scope(state: \.pageLoading, action: \.pageLoading)
					) { pageItem in
						itemView(pageItem)
					}
				}
			}
			.refreshable {
				store.send(.pageLoading(.refresh))
			}
			.listStyle(.grouped)
			.navigationBarTitleDisplayMode(.inline)
			.navigationTitle(.userSingleSelectorSelectUser)
			.task {
				store.send(.pageLoading(.initialize))
			}
		}
	}
}

private extension SingleSelector.ScreenList {
	func notSelectedView () -> some View {
		selectionContainerView(nil) {
			Text(.generalNotSelected)
				.frame(maxWidth: .infinity, alignment: .leading)
		}
	}

	func itemView (_ pageItem: PageItem<Item>) -> some View {
		selectionContainerView(pageItem) {
			itemView(pageItem.item)
		}
	}

	func selectionContainerView (_ pageItem: PageItem<Item>?, _ content: () -> some View) -> some View {
		HStack {
			if store.selectedItem == pageItem?.item {
				Image(systemName: "checkmark")
					.foregroundStyle(.tint)
			} else {
				Image(systemName: "checkmark").hidden()
			}

			content()
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.contentShape(.rect)
		.onTapGesture {
			store.send(.itemSelected(pageItem))
		}
	}
}
