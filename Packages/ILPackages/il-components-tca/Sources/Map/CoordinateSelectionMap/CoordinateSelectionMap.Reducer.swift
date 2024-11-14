import ComposableArchitecture
import CoreLocationUtils
import DLServices
import MapKit
import Multitool

public struct CoordinateSelectionMap: Reducer {
	@Dependency(\.locationService) var locationService
	@Dependency(\.dismiss) var dismiss

	public init () { }

	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .initialize: return initialize(&state)
			case .deinitialize: deinitialize()

			case .onLocationRequestCompleted(let requestResult): onLocationRequestCompleted(requestResult, &state)

			case .onCoordinateChanged(let coordinate): onCoordinateChanged(coordinate, &state)
			case .onMapFeatureSelected(let coordinate, let title): onMapFeatureSelected(coordinate, title, &state)

			case .onCancelButtonTap: return onCancelButtonTap()
			case .onSelectButtonTap: return onSelectButtonTap(state)

			case .onCoordinateSelected: break
			}

			return .none
		}
	}
}

private extension CoordinateSelectionMap {
	func initialize (_ state: inout State) -> Effect<Action> {
		requestLocation(&state)
	}

	func deinitialize () {
		locationService.stopUpdating()
	}

	func onLocationRequestCompleted (_ requestResult: Loadable<None>, _ state: inout State) {
		state.locationRequest = requestResult.replaceValue(with: locationService.location)
		locationService.startUpdating()
		
		if state.initialCoordinate == nil {
			state.initialCoordinate = locationService.location?.coordinate
		}
	}

	func onCoordinateChanged (_ coordinate: CLLocationCoordinate2D, _ state: inout State) {
		state.currentCoordinate = coordinate
	}

	func onMapFeatureSelected (_ coordinate: CLLocationCoordinate2D, _ title: String?, _ state: inout State) {
		state.selectedMapFeatureCoordinateTitle = title
		state.selectedMapFeatureCoordinate = coordinate
	}

	func onCancelButtonTap () -> Effect<Action> {
		.run { _ in
			await dismiss()
			deinitialize()
		}
	}

	func onSelectButtonTap (_ state: State) -> Effect<Action> {
		.run { send in
			let title = state.currentCoordinate == state.selectedMapFeatureCoordinate
				? state.selectedMapFeatureCoordinateTitle
				: nil
			
			if let currentCoordinate = state.currentCoordinate {
				await send(.onCoordinateSelected(currentCoordinate, title))
			}

			await dismiss()
			deinitialize()
		}
	}
}

private extension CoordinateSelectionMap {
	func requestLocation (_ state: inout State) -> Effect<Action> {
		state.locationRequest.setLoading()

		return .run { @MainActor send in
			let requestResult = await Loadable {
				try await locationService.requestAccess()
			}
			.replaceWithNone()

			send(.onLocationRequestCompleted(requestResult), animation: .default)
		}
	}
}
