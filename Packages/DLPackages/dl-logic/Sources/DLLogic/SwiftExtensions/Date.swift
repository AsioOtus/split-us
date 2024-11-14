import Foundation

public extension Date {
	func with (time: Bool, calendar: Calendar = .current) -> Date? {
		let components: Set<Calendar.Component> = time
		? [.year, .month, .day, .hour, .minute]
		: [.year, .month, .day]

		var dateComponents = calendar.dateComponents(components, from: self)

		if !time {
			dateComponents.hour = 0
			dateComponents.minute = 0
		} else {
			dateComponents.second = time ? 1 : 0
		}

		return calendar.date(from: dateComponents)
	}

	func hasTime (calendar: Calendar = .current) -> Bool {
		calendar.component(.second, from: self) != 0
	}
}
