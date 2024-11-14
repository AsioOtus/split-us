import ComponentsTCAExpense
import ComponentsTCAGeneral
import ComposableArchitecture
import DLModels
import DLServices
import Foundation
import ILComponents
import ILDebug
import Multitool

extension ExpenseEditing {
	@ObservableState
	public struct State: Equatable {
		let id: UUID
		let superExpenseGroupId: UUID?
		let userGroup: UserGroup
		
		var mode: Mode
		
		var expense: Expense?
		var expenseRequest: Loadable<Expense> = .initial

		var expenseInfoEditing: ExpenseInfoEditing.State
		var creditorSelector: SingleSelector<User.Compact>.State
		
		var amountValuePerItem: Int? = 100
		var itemCount: Int? = 1
		var currency: Currency
		
		var users: Loadable<[User.Compact]> = .initial
		var amountValueSplitInteractor: AmountValueSplitInteractor?
		
		var submitRequest: Loadable<None> = .initial
		
		var totalAmountValue: Int { (amountValuePerItem ?? 0) * (itemCount ?? 1) }

		var newExpense: Expense.New {
			.init(
				id: id,
				info: expenseInfoEditing.resultExpenseInfo,
				totalAmountValue: totalAmountValue,
				currencyId: currency.id,
				creditorId: creditorSelector.selectedPageItem?.item.id,
				borrowers: amountValueSplitInteractor?.selectedOrLockedUsers
					.map {
						Expense.New.Borrower(
							userId: $0.id,
							amountValue: $0.amountValue,
							isCompleted: false
						)
					} ?? []
			)
		}

		enum Mode {
			case creation
			case updating
			
			var isCreation: Bool { self == .creation }
			var isUpdating: Bool { self == .updating }
		}
		
		public static func creation (
			superExpenseGroupId: UUID?,
			userGroup: UserGroup
		) -> Self {
			let id = UUID()
			
			return .init(
				id: id,
				superExpenseGroupId: superExpenseGroupId,
				userGroup: userGroup,
				mode: .creation,
				expenseInfoEditing: .init(
					expenseInfo: nil,
					isExpenseGroup: false
				),
				creditorSelector: .init(
					sourceLoadingId: userGroup.id
				),
				currency: userGroup.defaultCurrency
			)
		}
		
		public static func updating (
			id: UUID,
			userGroup: UserGroup
		) -> Self {
			let id = UUID()
			
			return .init(
				id: id,
				superExpenseGroupId: nil,
				userGroup: userGroup,
				mode: .creation,
				expenseInfoEditing: .init(
					expenseInfo: nil,
					isExpenseGroup: false
				),
				creditorSelector: .init(
					sourceLoadingId: userGroup.id
				),
				currency: userGroup.defaultCurrency
			)
		}
	}
}
