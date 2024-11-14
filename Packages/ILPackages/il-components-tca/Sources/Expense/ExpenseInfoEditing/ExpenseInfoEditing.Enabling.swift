import ComposableArchitecture
import DLLogic
import DLModels

extension ExpenseInfoEditing {
	public struct Enabling: Equatable {
		public static let defaultExpense = Self(
			date: true,
			time: true,
			note: false,
			coordinate: false
		)

		public static let defaultExpenseGroup = Self(
			date: true,
			time: false,
			note: false,
			coordinate: false
		)

		public static let allDisabled = Self(
			date: false,
			time: false,
			note: false,
			coordinate: false
		)

		public static func create (expenseInfo: ExpenseInfo?, isExpenseGroup: Bool) -> Self {
			if let expenseInfo {
				.init(
					date: expenseInfo.date != nil,
					time: expenseInfo.date?.hasTime() != nil,
					note: expenseInfo.note != nil,
					coordinate: expenseInfo.coordinate != nil
				)
			} else if isExpenseGroup {
				.defaultExpenseGroup
			} else {
				.defaultExpense
			}
		}

		public var date: Bool
		public var time: Bool
		public var note: Bool
		public var coordinate: Bool

		public init (
			date: Bool,
			time: Bool,
			note: Bool,
			coordinate: Bool
		) {
			self.date = date
			self.time = time
			self.note = note
			self.coordinate = coordinate
		}
	}
}
