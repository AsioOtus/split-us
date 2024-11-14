import ComposableArchitecture
import ILDesignResources
import SwiftUI

public enum ExpenseUnitButtons {
	public static func addExpense (action: @escaping () -> Void) -> some View {
		Button(action: action) {
			Label(.expenseGroupAddExpense, systemImage: .sinAddExpense)
		}
		.tint(.green)
	}

	public static func createExpense (action: @escaping () -> Void) -> some View {
		addExpense(action: action)
			.buttonStyle(.bordered)
	}

	public static func editExpense (action: @escaping () -> Void) -> some View {
		Button(action: action) {
			Label(.generalActionEdit, systemImage: .sinGeneralEditing)
		}
		.tint(.blue)
	}

	public static func deleteExpense (action: @escaping () -> Void) -> some View {
		Button(action: action) {
			Label(.generalActionDelete, systemImage: .sinGeneralDeletion)
		}
		.tint(.red)
	}

	public static func addExpenseGroup (action: @escaping () -> Void) -> some View {
		Button(action: action) {
			Label(.expenseGroupAddExpenseGroup, systemImage: .sinAddExpenseGroup)
		}
		.tint(.green)
	}

	public static func createExpenseGroup (action: @escaping () -> Void) -> some View {
		addExpenseGroup(action: action)
			.buttonStyle(.bordered)
	}

	public static func editExpenseGroup (action: @escaping () -> Void) -> some View {
		Button(action: action) {
			Label(.generalActionEdit, systemImage: .sinGeneralEditing)
		}
		.tint(.blue)
	}

	public static func controls (
		createExpense: @escaping () -> Void,
		createExpenseGroup: @escaping () -> Void
	) -> some View {
		HStack {
			ExpenseUnitButtons.createExpenseGroup(action: createExpenseGroup)
			ExpenseUnitButtons.createExpense(action: createExpense)
		}
		.frame(maxWidth: .infinity)
	}
}
