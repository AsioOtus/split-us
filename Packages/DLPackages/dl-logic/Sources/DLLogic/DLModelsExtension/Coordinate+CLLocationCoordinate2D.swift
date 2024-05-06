import CoreLocation
import DLModels

public extension Coordinate {
	init (clLocationCoordinate2d: CLLocationCoordinate2D) {
		self.init(
			latitude: clLocationCoordinate2d.latitude,
			longitude: clLocationCoordinate2d.longitude
		)
	}
}

public extension Coordinate {
	var clLocationCoordinate2d: CLLocationCoordinate2D {
		.init(latitude: latitude, longitude: longitude)
	}
}
