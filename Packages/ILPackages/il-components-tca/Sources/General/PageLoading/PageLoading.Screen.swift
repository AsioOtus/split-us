import ComposableArchitecture
import DLModels
import ILComponents
import SwiftUI

extension PageLoading {
	public struct Screen <ItemView: View>: View {
		let store: StoreOf<Reducer>
		let itemView: (PageItem<Item>) -> ItemView

		public init (
			store: StoreOf<Reducer>,
			itemView: @escaping (PageItem<Item>) -> ItemView
		) {
			self.store = store
			self.itemView = itemView
		}

		public var body: some View {
			ForEach(store.items, id: \.self) { pageItem in
				itemView(pageItem)
					.task { store.send(.onItemDisplayed(pageItem)) }
			}
			.task { store.send(.initialize) }

			if let error = store.error {
				StandardErrorView(error: error) {
					RetryButton {
						store.send(.loadNextPage)
					}
				}
			}

			if store.isLoading, !store.isRefreshing {
				StandardLoadingView()
			}
		}
	}
}
