import ComposableArchitecture
import DLModels
import ILComponents
import SwiftUI

extension ExpenseUnitsFeature {
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
			contentView()
				.task { store.send(.initialize) }
				.refreshable { await store.send(.refresh).finish() }
		}
	}
}

// MARK: - Subviews
private extension ExpenseUnitsFeature.Screen {
	@ViewBuilder
	func contentView () -> some View {
		if !store.expenseUnits.isEmpty {
			expenseUnitsView()
		} else {
			emptyView()
		}
	}

	func expenseUnitsView () -> some View {
		ForEach(store.scope(state: \.expenseUnits, action: \.expenseUnits)) { expenseUnitStore in
			ExpenseUnitFeature.Screen(
				store: expenseUnitStore,
				expenseView: expenseView,
				expenseGroupView: expenseGroupView
			)
		}
	}

	@ViewBuilder
	func emptyView () -> some View {
		if store.isRoot {
			StandardEmptyView(message: .expensesEmptyMessage, systemImage: .sinExpenses)
				.listRowSeparator(.hidden)
		} else {
			EmptyView()
		}
	}
}
