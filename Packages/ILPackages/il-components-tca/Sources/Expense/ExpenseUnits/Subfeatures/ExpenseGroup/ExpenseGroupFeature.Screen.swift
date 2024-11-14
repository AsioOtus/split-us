import ComposableArchitecture
import DLModels
import SwiftUI

extension ExpenseGroupFeature {
	public struct Screen <ExpenseContent: View, ExpenseGroupContent: View>: View {
		@Bindable var store: StoreOf<Reducer>

		let expenseView: (Expense, UUID?) -> ExpenseContent
		let expenseGroupView: (ExpenseGroup, UUID?) -> ExpenseGroupContent

		public init (
			store: StoreOf<Reducer>,
			@ViewBuilder expenseView: @escaping (Expense, UUID?) -> ExpenseContent,
			@ViewBuilder expenseGroupView: @escaping (ExpenseGroup, UUID?) -> ExpenseGroupContent
		) {
			self.store = store
			self.expenseView = expenseView
			self.expenseGroupView = expenseGroupView
		}

		public var body: some View {
			DisclosureGroup(
				isExpanded: $store.isExpanded,
				content: {
					expenseUnitsView()
				},
				label: {
					expenseGroupLabelView()
				}
			)
		}
	}
}

private extension ExpenseGroupFeature.Screen {
	func expenseUnitsView () -> some View {
		ExpenseUnitsFeature.Screen(
			store: store.scope(state: \.expenseUnits, action: \.expenseUnits),
			expenseView: expenseView,
			expenseGroupView: expenseGroupView
		)
	}

	func expenseGroupLabelView () -> some View {
		expenseGroupView(store.expenseGroup, store.superExpenseGroupId)
			.swipeActions(edge: .leading, allowsFullSwipe: false) {
				deleteExpenseGroupButton()
			}
			.swipeActions {
				addExpenseButton()
				addExpenseGroupButton()
				editExpenseGroupButton()
			}
			.contextMenu {
				expenseGroupContextMenuView()
			}
	}
}

private extension ExpenseGroupFeature.Screen {
	@ViewBuilder
	func expenseGroupContextMenuView () -> some View {
		addExpenseButton()
		addExpenseGroupButton()
		Divider()
		editExpenseGroupButton()
		Divider()
		deleteExpenseGroupButton()
	}

	func addExpenseButton () -> some View {
		ExpenseUnitButtons.addExpense {
			store.send(.onAddExpenseButtonTap(superExpenseGroup: store.expenseGroup))
		}
	}

	func addExpenseGroupButton () -> some View {
		ExpenseUnitButtons.addExpenseGroup {
			store.send(.onAddExpenseGroupButtonTap(superExpenseGroup: store.expenseGroup))
		}
	}

	func editExpenseGroupButton () -> some View {
		ExpenseUnitButtons.editExpense {
			store.send(.onUpdateButtonTap(store.expenseGroup))
		}
	}

	func deleteExpenseGroupButton () -> some View {
		ExpenseUnitButtons.deleteExpense {
			store.send(.onDeleteButtonTap(store.expenseGroup))
		}
	}
}
