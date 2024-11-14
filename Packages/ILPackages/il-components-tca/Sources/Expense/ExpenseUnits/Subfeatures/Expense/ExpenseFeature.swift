import ComposableArchitecture
import DLModels
import Foundation

public enum ExpenseFeature {
	@ObservableState
	public struct State: Hashable {
		public let userGroupId: UUID
		public let superExpenseGroupId: UUID?
		public let page: Page
		public let expense: Expense

		public init (
			expense: Expense,
			page: Page,
			superExpenseGroupId: UUID?,
			userGroupId: UUID
		) {
			self.expense = expense
			self.page = page
			self.superExpenseGroupId = superExpenseGroupId
			self.userGroupId = userGroupId
		}
	}

	@CasePathable
	public enum Action {

	}
}
