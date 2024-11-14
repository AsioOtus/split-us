public struct Coordinate: Hashable, Codable {
	public let latitude: Double
	public let longitude: Double

	public init (
		latitude: Double,
		longitude: Double
	) {
		self.latitude = latitude
		self.longitude = longitude
	}
}

extension Coordinate: RawRepresentable {
	public init? (rawValue: String) {
		let components = rawValue.split(separator: " ").compactMap(Double.init)

		guard components.count == 2 else { return nil }

		self.init(latitude: components[0], longitude: components[1])
	}
	
	public var rawValue: String {
		"\(latitude) \(longitude)"
	}
}
