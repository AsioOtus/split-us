import ComponentsTCAExpense
import ComponentsTCAGeneral
import ComponentsTCAUser
import ComposableArchitecture
import DLModels
import DLServices
import Foundation
import struct IdentifiedCollections.Identified
import Multitool
import ScreenExpenseEditing

extension ExpenseGroupEditing {
	@ObservableState
	public struct State: Equatable {
		let superExpenseGroupId: UUID?
		let userGroup: UserGroup

		var mode: Mode
		var id: UUID

		var expenseGroup: ExpenseGroup?
		var expenseGroupRequest: Loadable<ExpenseGroup> = .initial
		var submitRequest: Loadable<None> = .initial

		var connectionStateFeature: ConnectionStateFeature.State = .init()

		@Presents var expenseEditing: ExpenseEditing.State?
		@Presents var expenseGroupEditing: ExpenseGroupEditing.State?

		var userSelector: SingleSelector<User.Compact>.State
		var expenseInfoEditing: ExpenseInfoEditing.State
		var expenseUnitsFeature: ExpenseUnitsFeature.State

		var editingError: EditingError? {
			didSet {
				if editingError == nil { return }
				isErrorToastVisible = true
			}
		}

		var isErrorToastVisible: Bool = false {
			didSet {
				if isErrorToastVisible { return }
				editingError = nil
			}
		}

		var isLocalCreationInfoToastVisible: Bool = false

		var newExpenseGroup: ExpenseGroup.New {
			.init(
				id: id,
				info: expenseInfoEditing.resultExpenseInfo
			)
		}

		var updateExpenseGroup: ExpenseGroup.Update {
			.init(
				id: id,
				info: expenseInfoEditing.resultExpenseInfo
			)
		}

		var isChanged: Bool {
			if let expenseGroup {
				expenseInfoEditing.resultExpenseInfo != expenseGroup.info
			} else {
				false
			}
		}

		enum Mode {
			case review
			case creation
			case updating

			var isReview: Bool { self == .review }
			var isCreation: Bool { self == .creation }
			var isUpdating: Bool { self == .updating }
		}
	}
}

public extension ExpenseGroupEditing.State {
	static func creation (
		superExpenseGroupId: UUID?,
		userGroup: UserGroup
	) -> Self {
		let id = UUID()

		return .init(
			superExpenseGroupId: superExpenseGroupId,
			userGroup: userGroup,
			mode: .creation,
			id: id,
			userSelector: .init(
				sourceLoadingId: userGroup.id
			),
			expenseInfoEditing: .init(
				expenseInfo: nil,
				isExpenseGroup: true
			),
			expenseUnitsFeature: .init(
				isRoot: true,
				superExpenseGroupId: id,
				userGroupId: userGroup.id
			)
		)
	}
	
	static func updating (
		expenseGroupId: UUID,
		userGroup: UserGroup
	) -> Self {
		.init(
			superExpenseGroupId: nil,
			userGroup: userGroup,
			mode: .updating,
			id: expenseGroupId,
			userSelector: .init(sourceLoadingId: userGroup.id),
			expenseInfoEditing: .init(
				expenseInfo: nil,
				isExpenseGroup: true
			),
			expenseUnitsFeature: .init(
				isRoot: true,
				superExpenseGroupId: expenseGroupId,
				userGroupId: userGroup.id
			)
		)
	}
}

public extension ExpenseGroupEditing.State {
	enum EditingError: Error {
		case creationError
		case updatingError
		case currentUserIsNil
		case offlineUpdateAttempt
	}
}

extension ExpenseGroupEditing.State {
	public struct SharedInfo: Equatable {
		public var isEnabled = false
		public var currency: Currency
		public var creditor: User.Compact?
		public var amountValue: Int?
		public var remainingAmountValue: Int?

		public init (
			isEnabled: Bool = false,
			currency: Currency,
			creditor: User.Compact? = nil,
			amountValue: Int? = nil,
			remainingAmountValue: Int? = nil
		) {
			self.isEnabled = isEnabled
			self.currency = currency
			self.creditor = creditor
			self.amountValue = amountValue
			self.remainingAmountValue = remainingAmountValue
		}

		func set (amountValue: Int) -> Self {
			.init(
				isEnabled: isEnabled,
				currency: currency,
				creditor: creditor,
				amountValue: amountValue,
				remainingAmountValue: remainingAmountValue
			)
		}
	}
}
