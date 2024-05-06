import ComposableArchitecture
import SwiftUI
import UnavailablePlaceholderComponents

extension Transfers {
	public struct Screen: View {
		let store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}
		
		public var body: some View {
			if store.transferUnits.count > 0 {
				ForEach(store.transferUnits, id: \.self) { transferUnit in
					TransferUnitRowView(
						store: store,
						transferUnit: transferUnit,
						superTransferGroup: store.superTransferGroup
					)
				}
			} else {
				StandardEmptyView(message: .transfersEmptyMessage, systemImage: "rectangle.on.rectangle")
			}
		}
	}
}
