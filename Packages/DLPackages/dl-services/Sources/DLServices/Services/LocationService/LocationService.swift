import Dependencies
import CoreLocation
import Combine

public protocol PLocationService {
	var location: CLLocation? { get }
	var locationPublisher: any Publisher<CLLocation, Never> { get }

	func requestAccess () async throws
	func startUpdating ()
	func stopUpdating ()
}

public enum LocationServiceError: Swift.Error {
	case locationAccessDisabled
	case locationAccessUnknown
}

public class LocationService: NSObject, PLocationService {
	private var accessRequestContinuation: CheckedContinuation<Void, Error>?

	let locationManager = CLLocationManager()

	public var location: CLLocation? {
		locationManager.location
	}

	public var locationPublisher: any Publisher<CLLocation, Never> {
		locationManager.location.publisher
	}

	public override init () {
		super.init()

		locationManager.delegate = self
	}

	public func requestAccess () async throws {
		switch locationManager.authorizationStatus {
		case .notDetermined:
			try await requestAccessAsync()

		case .restricted, .denied:
			throw LocationServiceError.locationAccessDisabled

		case .authorizedAlways, .authorizedWhenInUse:
			break

		@unknown default:
			throw LocationServiceError.locationAccessUnknown
		}
	}

	public func startUpdating () {
		locationManager.startUpdatingLocation()
	}

	public func stopUpdating () {
		locationManager.stopUpdatingLocation()
	}
}

extension LocationService: CLLocationManagerDelegate {
	public func locationManager (_: CLLocationManager, didUpdateLocations locations: [CLLocation]) { }

	public func locationManager (_: CLLocationManager, didFailWithError error: Error) { }

	public func locationManagerDidChangeAuthorization (_: CLLocationManager) {
		switch locationManager.authorizationStatus {
		case .notDetermined:
			break

		case .restricted, .denied:
			accessRequestContinuation?.resume(throwing: LocationServiceError.locationAccessDisabled)
			accessRequestContinuation = nil

		case .authorizedAlways, .authorizedWhenInUse:
			accessRequestContinuation?.resume()
			accessRequestContinuation = nil

		@unknown default:
			accessRequestContinuation?.resume(throwing: LocationServiceError.locationAccessUnknown)
			accessRequestContinuation = nil
		}
	}
}

private extension LocationService {
	func requestAccessAsync () async throws {
		try await withCheckedThrowingContinuation { continuation in
			accessRequestContinuation = continuation

			locationManager.requestWhenInUseAuthorization()
		}
	}
}

struct LocationServiceDependencyKey: DependencyKey {
	public static var liveValue: PLocationService {
		LocationService()
	}
}

public extension DependencyValues {
	var locationService: PLocationService {
		get { self[LocationServiceDependencyKey.self] }
		set { self[LocationServiceDependencyKey.self] = newValue }
	}
}
