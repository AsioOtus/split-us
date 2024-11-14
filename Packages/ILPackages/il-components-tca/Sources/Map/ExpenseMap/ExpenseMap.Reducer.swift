import ComposableArchitecture
import CoreLocation
import DLServices

public struct ExpenseMap: Reducer {
	@Dependency(\.locationService) var locationService

	public init () { }

	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .initialize: return initialize(&state)
			case .deinitialize: deinitialize(state)
				
			case .onLocationRequestCompleted: onLocationRequestCompleted(&state)
			case .onCoordinateChanged(let coordinate): onCoordinateChanged(coordinate, &state)
			case .onExpandButtonTap: onExpandButtonTap(&state)

			case .coordinateSelectionMap(.presented(.onCoordinateSelected(let coordinate, let title))): onCoordinateSelected(coordinate, title, &state)
			case .coordinateSelectionMap: break
			}

			return .none
		}
		.ifLet(\.$coordinateSelectionMap, action: \.coordinateSelectionMap) {
			CoordinateSelectionMap()
		}
	}
}

private extension ExpenseMap {
	func initialize (_ state: inout State) -> Effect<Action> {
		return requestLocation(&state)
	}

	func deinitialize (_ state: State) {
		locationService.stopUpdating()
	}

	func onLocationRequestCompleted (_ state: inout State) {
		locationService.startUpdating()

		if state.selectedCoordinate == nil {
			if let coordinate = locationService.location?.coordinate {
				state.currentCoordinate = coordinate
				state.selectedCoordinate = coordinate
			} else {
				state.selectedCoordinate = state.currentCoordinate
			}
		}
	}

	func onCoordinateChanged (_ coordinate: CLLocationCoordinate2D, _ state: inout State) {
		state.currentCoordinate = coordinate
	}

	func onExpandButtonTap (_ state: inout State) {
		state.coordinateSelectionMap = .init(initialCoordinate: state.currentCoordinate)
	}

	func onCoordinateSelected (_ coordinate: CLLocationCoordinate2D, _ title: String?, _ state: inout State) {
		state.currentCoordinate = coordinate
		state.selectedTitle = title
		state.selectedCoordinate = coordinate
	}
}

private extension ExpenseMap {
	func requestLocation (_ state: inout State) -> Effect<Action> {
		return .run { @MainActor send in
			try? await locationService.requestAccess()
			send(.onLocationRequestCompleted)
		}
	}
}
