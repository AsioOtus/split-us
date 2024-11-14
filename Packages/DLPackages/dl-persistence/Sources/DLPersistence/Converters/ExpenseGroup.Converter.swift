import CoreData
import DLModels

extension ExpenseGroup {
	struct Converter {
		static let `default` = Self()

		let userConverter = User.Compact.Converter.default

		func convert (_ entity: ExpenseEntity) -> ExpenseGroup {
			.init(
				id: entity.id,
				info: .init(
					name: entity.name,
					note: entity.note,
					date: entity.date,
					timeZone: .current,
					coordinate: entity.coordinate.flatMap(Coordinate.init(rawValue:))
				),
				offlineStatus: .init(rawValue: entity.offlineStatus) ?? .cached,
				creator: userConverter.convert(entity.creator)
			)
		}
	}
}
