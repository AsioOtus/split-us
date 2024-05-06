import ComposableArchitecture
import MapKit

extension ExpenseMap {
	@ObservableState
	public struct State {
		public var currentCoordinate: CLLocationCoordinate2D?
		public var selectedCoordinate: CLLocationCoordinate2D?
		public var selectedTitle: String?

		@Presents public var coordinateSelectionMap: CoordinateSelectionMap.State?

		public init (selectedCoordinate: CLLocationCoordinate2D?) {
			self.selectedCoordinate = selectedCoordinate
		}
	}
}

extension ExpenseMap {
	@CasePathable
	public enum Action {
		case initialize
		case deinitialize

		case onLocationRequestCompleted
		case onCoordinateChanged(CLLocationCoordinate2D)
		case onExpandButtonTap

		case coordinateSelectionMap(PresentationAction<CoordinateSelectionMap.Action>)
	}
}
