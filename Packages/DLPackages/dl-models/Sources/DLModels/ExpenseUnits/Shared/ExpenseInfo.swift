import Foundation

public struct ExpenseInfo: Hashable, Codable {
	public var name: String?
	public var note: String?
	public var date: Date?
	public var timeZone: TimeZone
	public var coordinate: Coordinate?

	public var allNil: Bool {
		name == nil && note == nil && date == nil && coordinate == nil
	}

	public init (
		name: String? = nil,
		note: String? = nil,
		date: Date? = nil,
		timeZone: TimeZone = .current,
		coordinate: Coordinate? = nil
	) {
		self.name = name
		self.note = note
		self.date = date
		self.timeZone = timeZone
		self.coordinate = coordinate
	}
}
