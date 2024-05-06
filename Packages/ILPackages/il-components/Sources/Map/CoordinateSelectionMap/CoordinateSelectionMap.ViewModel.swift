import ComposableArchitecture
import MapKit
import SwiftUI

extension CoordinateSelectionMap {
	@Observable
	class ViewModel {
		var store: StoreOf<CoordinateSelectionMap>

		var selectedMapFeature: MapFeature?

		var useHybridMapStyle = false

		var mapStyle: MapStyle {
			useHybridMapStyle ? .hybrid : .standard
		}

		var positionBinding: Binding<MapCameraPosition> {
			.init(
				get: {
					if let coordinate = self.store.selectedMapFeatureCoordinate {
						.camera(.init(centerCoordinate: coordinate, distance: 1000))
					} else if let coordinate = self.store.initialCoordinate {
						.camera(.init(centerCoordinate: coordinate, distance: 1000))
					} else {
						.automatic
					}
				},
				set: { _ in }
			)
		}

		var selectedMapFeatureBinding: Binding<MapFeature?> {
			.init(
				get: {
					self.selectedMapFeature
				},
				set: {
					self.selectedMapFeature = $0

					if let selectedMapFeature = self.selectedMapFeature {
						self.store.send(.onMapFeatureSelected(selectedMapFeature.coordinate, selectedMapFeature.title), animation: .default)
					}
				}
			)
		}

		init (store: StoreOf<CoordinateSelectionMap>) {
			self.store = store
		}
	}
}
