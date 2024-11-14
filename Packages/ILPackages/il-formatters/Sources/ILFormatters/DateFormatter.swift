import Foundation

public extension DateFormatter {
	static let withTime: DateFormatter = {
		$0.dateFormat = "dd.MM.yyyy HH:mm"
		return $0
	}(DateFormatter())

	static let withoutTime: DateFormatter = {
		$0.dateFormat = "dd.MM.yyyy"
		return $0
	}(DateFormatter())

	static func with (time: Bool) -> DateFormatter {
		time ? .withTime : .withoutTime
	}
}
