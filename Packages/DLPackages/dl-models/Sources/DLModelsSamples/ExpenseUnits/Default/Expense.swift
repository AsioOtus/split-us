import DLModels
import Multitool

public extension Expense {
	static let beer = Self(
		id: .create(1),
		info: .init(
			name: "Пиво",
			date: .init(timeIntervalSince1970: 1719792000)
		),
		totalAmount: .init(value: 12, currency: .eur),
		creditor: .valdis,
		borrowers: [
			.init(
				user: .ostap,
				amountValue: 4,
				isCompleted: false
			),
			.init(
				user: .valdis,
				amountValue: 4,
				isCompleted: false
			),
			.init(
				user: .alexander,
				amountValue: 4,
				isCompleted: false
			),
		],
		offlineStatus: .cached,
		creator: .ostap
	)

	static let train = Self(
		id: .create(2),
		info: .init(
			name: "Билет на поезд",
			note: "Не очень длинный комментарий",
			date: .init(timeIntervalSince1970: 1719792000)
		),
		totalAmount: .init(value: 24, currency: .eur),
		creditor: .ignat,
		borrowers: [
			.init(
				user: .ignat,
				amountValue: 6,
				isCompleted: false
			),
			.init(
				user: .ostap,
				amountValue: 6,
				isCompleted: false
			),
			.init(
				user: .alexander,
				amountValue: 6,
				isCompleted: false
			),
			.init(
				user: .valdis,
				amountValue: 6,
				isCompleted: false
			),
		],
		offlineStatus: .cached,
		creator: .ostap
	)

	static let iceCream = Self(
		id: .create(3),
		info: .init(
			name: "Мороженное",
			note: "Длинный длинный длинный длинный длинный длинный длинный длинный длинный длинный длинный длинный длинный длинный длинный длинный длинный длинный длинный комментарий",
			date: .init(timeIntervalSince1970: 1719792000),
			coordinate: .riga
		),
		totalAmount: .init(value: 56, currency: .eur),
		creditor: .alexander,
		borrowers: [
			.init(
				user: .alexander,
				amountValue: 12,
				isCompleted: false
			),
			.init(
				user: .ostap,
				amountValue: 4,
				isCompleted: false
			),
			.init(
				user: .ignat,
				amountValue: 20,
				isCompleted: false
			),
			.init(
				user: .valdis,
				amountValue: 20,
				isCompleted: false
			),
		],
		offlineStatus: .cached,
		creator: .ostap
	)

	static let longName = Self(
		id: .create(4),
		info: .init(
			name: "Длинное длинное длинное длинное длинное длинное длинное имя",
			note: "Комментарий",
			date: .init(timeIntervalSince1970: 1719792000),
			coordinate: .riga
		),
		totalAmount: .init(value: 10, currency: .eur),
		creditor: .ostap,
		borrowers: [
			.init(
				user: .ostap,
				amountValue: nil,
				isCompleted: false
			)
		],
		offlineStatus: .cached,
		creator: .ostap
	)
}
