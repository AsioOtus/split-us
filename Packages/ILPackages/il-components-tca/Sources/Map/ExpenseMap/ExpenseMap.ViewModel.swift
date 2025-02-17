import ComposableArchitecture
import MapKit
import SwiftUI

extension ExpenseMap {
	@Observable
	final class ViewModel {
		var store: StoreOf<ExpenseMap>

		var positionBinding: Binding<MapCameraPosition> {
			.init(
				get: {
					if let coordinate = self.store.currentCoordinate {
						.camera(.init(centerCoordinate: coordinate, distance: 500))
					} else {
						.automatic
					}
				},
				set: { _ in }
			)
		}

		init (store: StoreOf<ExpenseMap>) {
			self.store = store
		}
	}
}
