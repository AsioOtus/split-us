import ComponentsTCAExpense
import ComponentsTCAGeneral
import ComponentsTCAUser
import ComposableArchitecture
import DLModels
import DLServices
import Foundation
import Multitool
import ScreenExpenseEditing

extension ExpenseGroupEditing {
	@CasePathable
	public indirect enum Action: BindableAction {
		case binding(BindingAction<State>)

		case initialize

		case onActionButtonTap
		case onCancelButtonTap

		case saveLocalSuccess
		case saveLocalFailure(Error)

		case onExpenseGroupLoadingSuccess(ExpenseGroup)
		case onExpenseGroupLoadingFailure(Error)
		case onCreationSuccess(ExpenseGroup)
		case onCreationFailure(Error)
		case onUpdatingSuccess(ExpenseGroup)
		case onUpdatingFailure(Error)

		case onAddExpenseButtonTap
		case onAddExpenseGroupButtonTap

		case expenseUnitEvent(ExpenseUnitsEvent)

		case expenseEditing(PresentationAction<ExpenseEditing.Action>)
		case expenseGroupEditing(PresentationAction<ExpenseGroupEditing.Action>)
		case connectionStateFeature(ConnectionStateFeature.Action)
		case userSelector(SingleSelector<User.Compact>.Action)
		case expenseInfoEditing(ExpenseInfoEditing.Action)
		case expenseUnitsFeature(ExpenseUnitsFeature.Action)
	}
}
