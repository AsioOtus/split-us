import ComposableArchitecture
import DLModels
import ILComponents
import SwiftUI

extension SingleSelector {
	public struct ScreenPicker <ItemView: View>: View {
		@Bindable var store: StoreOf<Reducer>
		let itemView: (Item) -> ItemView

		public init (
			store: StoreOf<Reducer>,
			@ViewBuilder itemView: @escaping (Item) -> ItemView
		) {
			self.store = store
			self.itemView = itemView
		}

		public var body: some View {
			Section {
				Button {
					store.send(.onListButtonTap)
				} label: {
					Label(.generalList, systemImage: "chevron.forward")
				}
			}

			Picker(selection: $store.selectedPageItem) {
				Text(.generalNotSelected)
					.tag(PageItem<Item>?.none)
				Divider()

				PageLoading<Item>.Screen(
					store: store.scope(state: \.pageLoading, action: \.pageLoading)
				) { pageItem in
					itemView(pageItem.item)
						.tag(PageItem<Item>?.some(pageItem))
				}
			} label: { }
				.task {
					store.send(.pageLoading(.initialize))
				}
		}
	}
}
