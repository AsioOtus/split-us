import ComponentsTCAMap
import ComposableArchitecture
import DLModels
import DLLogic

public enum ExpenseInfoEditing {
	@ObservableState
	public struct State: Equatable {
		var expenseInfo: ExpenseInfo
		public var isEnabled: Enabling

		public var expenseMap: ExpenseMap.State

		public var resultExpenseInfo: ExpenseInfo {
			.init(
				name: expenseInfo.name,
				note: isEnabled.note ? expenseInfo.note : nil,
				date: isEnabled.date ? expenseInfo.date : nil,
				timeZone: .current,
				coordinate: isEnabled.coordinate ? expenseMap.selectedCoordinate.map(Coordinate.init) : nil
			)
		}

		public init (
			expenseInfo: ExpenseInfo?,
			isExpenseGroup: Bool
		) {
			self.expenseInfo = (expenseInfo ?? .init()).nonNil
			self.isEnabled = .create(expenseInfo: expenseInfo, isExpenseGroup: isExpenseGroup)
			self.expenseMap = .init(selectedCoordinate: expenseInfo?.coordinate?.clLocationCoordinate2d)
		}

		public mutating func set (expenseInfo: ExpenseInfo, isExpenseGroup: Bool) {
			self.expenseInfo = expenseInfo.nonNil

			self.isEnabled = .create(
				expenseInfo: expenseInfo,
				isExpenseGroup: isExpenseGroup
			)
		}
	}

	@CasePathable
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		
		case expenseMap(ExpenseMap.Action)
	}
}

fileprivate extension ExpenseInfo {
	var nonNil: Self {
		.init(
			name: name,
			note: note ?? "",
			date: date ?? .init(),
			timeZone: timeZone,
			coordinate: coordinate
		)
	}
}
