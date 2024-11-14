import CoreData
import DLModels

extension Expense {
	struct Converter {
		static let `default` = Self()

		let userConverter = User.Compact.Converter.default

		func convert (_ entity: ExpenseEntity) -> Expense {
			.init(
				id: entity.id,
				info: .init(
					name: entity.name,
					note: entity.note,
					date: entity.date,
					timeZone: .current,
					coordinate: entity.coordinate.flatMap(Coordinate.init(rawValue:))
				),
				totalAmount: .init(
					value: entity.amount?.intValue,
					currency: .init(
						id: .init(),
						code: entity.currencyCode
					)
				),
				creditor: entity.creditor.map(userConverter.convert),
				borrowers: entity.allBorrowers.map {
					.init(
						user: userConverter.convert($0.borrower),
						amountValue: $0.amountValue?.intValue,
						isCompleted: $0.isCompleted
					)
				},
				offlineStatus: .init(rawValue: entity.offlineStatus) ?? .cached,
				creator: userConverter.convert(entity.creator)
			)
		}
	}
}
