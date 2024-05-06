import ComposableArchitecture
import CoreLocation
import MapKit
import Multitool
import DLUtils

extension CoordinateSelectionMap {
	@ObservableState
	public struct State: Equatable {
		var locationRequest = Loadable<CLLocation?>.initial()
		var initialCoordinate: CLLocationCoordinate2D?
		var existingCoordinate: CLLocationCoordinate2D?
		var currentCoordinate: CLLocationCoordinate2D?
		var selectedMapFeatureCoordinate: CLLocationCoordinate2D?
		var selectedMapFeatureCoordinateTitle: String?

		public init (initialCoordinate: CLLocationCoordinate2D?) {
			if let initialCoordinate {
				self.initialCoordinate = initialCoordinate
				self.existingCoordinate = initialCoordinate
			}
		}
	}
}

extension CoordinateSelectionMap {
	public enum Action {
		case initialize
		case deinitialize

		case onLocationRequestCompleted(Loadable<None>)

		case onCoordinateChanged(CLLocationCoordinate2D)
		case onMapFeatureSelected(CLLocationCoordinate2D, String?)

		case onCancelButtonTap
		case onSelectButtonTap

		case onCoordinateSelected(CLLocationCoordinate2D, String?)
	}
}
