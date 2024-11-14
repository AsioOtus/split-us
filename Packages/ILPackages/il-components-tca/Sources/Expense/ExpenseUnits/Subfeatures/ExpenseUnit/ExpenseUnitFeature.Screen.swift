import ComposableArchitecture
import DLModels
import SwiftUI

extension ExpenseUnitFeature {
	public struct Screen <ExpenseContent: View, ExpenseGroupContent: View>: View {
		let store: StoreOf<Reducer>

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
				.listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
		}
	}
}

private extension ExpenseUnitFeature.Screen  {
	@ViewBuilder
	func contentView () -> some View {
		switch store.state {
		case .expense:
			if let store = store.scope(state: \.[case: \.expense], action: \.expense) {
				ExpenseFeature.Screen(
					store: store,
					expenseView: expenseView
				)
			}

		case .expenseGroup:
			if let store = store.scope(state: \.[case: \.expenseGroup], action: \.expenseGroup) {
				ExpenseGroupFeature.Screen(
					store: store,
					expenseView: expenseView,
					expenseGroupView: expenseGroupView
				)
			}
		}
	}
}
