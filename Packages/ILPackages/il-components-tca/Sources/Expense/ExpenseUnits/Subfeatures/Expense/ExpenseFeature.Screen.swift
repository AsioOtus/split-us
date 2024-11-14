import ComposableArchitecture
import DLModels
import SwiftUI

extension ExpenseFeature {
	public struct Screen <ExpenseContent: View>: View {
		let store: StoreOf<Reducer>
		
		let expenseView: (Expense, UUID?) -> ExpenseContent

		public init (
			store: StoreOf<Reducer>,
			@ViewBuilder expenseView: @escaping (Expense, UUID?) -> ExpenseContent
		) {
			self.store = store
			self.expenseView = expenseView
		}

		public var body: some View {
			expenseView(store.expense, store.superExpenseGroupId)
		}
	}
}
