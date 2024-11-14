import Dependencies
import DLModels
import DLServices

struct ExpenseUnitDataProvider {
	@Dependency(\.expenseService) var expenseService

	func loadNext (page: Page, source: ExpenseUnitSource) async throws -> [ExpenseUnit.Default] {
		switch source {
		case .userGroup(let userGroupId):
			try await expenseService.expenseUnits(userGroupId: userGroupId, page: page)
		case .superExpenseGroup(let superExpenseGroupId):
			try await expenseService.expenseUnits(expenseGroupId: superExpenseGroupId, page: page)
		}
	}
}
