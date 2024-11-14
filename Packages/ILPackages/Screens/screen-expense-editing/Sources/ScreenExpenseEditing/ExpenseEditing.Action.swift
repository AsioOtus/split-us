import ComponentsTCAExpense
import ComponentsTCAGeneral
import ComponentsTCAUser
import ComposableArchitecture
import DLServices
import DLModels
import Foundation
import ILComponents
import Multitool

extension ExpenseEditing {
	@CasePathable
	public enum Action: BindableAction {
		case binding(BindingAction<State>)

		case initialize
		case refresh

		case onSubmitButtonTap
		case onCancelButtonTap

		case onCreationCompleted(Loadable<ExpenseTree>)
		case onUpdatingCompleted(Loadable<ExpenseTree>)

		case onUsersResponse(Loadable<[User.Compact]>)

		case expenseInfoEditing(ExpenseInfoEditing.Action)
		case creditorSelector(SingleSelector<User.Compact>.Action)
	}
}
