import Dependencies
import DLModels
import Foundation

public protocol PExpenseLocalService {
	func expense (
		id: UUID
	) throws -> Expense?

	func expenseGroup (
		id: UUID
	) throws -> ExpenseGroup?

	func expenseUnits (
		userGroupId: UUID,
		page: Page
	) throws -> [ExpenseUnit.Default]

	func expenseUnits (
		expenseGroupId: UUID,
		page: Page
	) throws -> [ExpenseUnit.Default]

	func saveExpense (
		_ newExpense: Expense.New,
		superExpenseGroupId: UUID?,
		userGroupId: UUID,
		creatorId: UUID
	) throws

	func saveExpenseGroup (
		_ newExpenseGroup: ExpenseGroup.New,
		superExpenseGroupId: UUID?,
		userGroupId: UUID,
		creatorId: UUID
	) throws

	func createExpense (
		_ newExpense: Expense.New,
		superExpenseGroupId: UUID?,
		userGroupId: UUID
	) throws

	func createExpenseGroup (
		_ newExpenseGroup: ExpenseGroup.New,
		superExpenseGroupId: UUID?,
		userGroupId: UUID
	) throws

	func delete (id: UUID) throws
}

public struct ExpenseLocalService: PExpenseLocalService {
	@Dependency(\.expensePersistentRepository) var expensePersistentRepository
	@Dependency(\.currentUserService) var currentUserService
	@Dependency(\.date) var date

	public func expense (id: UUID) throws -> Expense? {
		try expensePersistentRepository.loadExpense(id: id)
	}

	public func expenseGroup (id: UUID) throws -> ExpenseGroup? {
		try expensePersistentRepository.loadExpenseGroup(id: id)
	}

	public func expenseUnits (userGroupId: UUID, page: Page) throws -> [ExpenseUnit.Default] {
		try expensePersistentRepository.loadUserGroupExpenses(userGroupId: userGroupId, page: page)
	}

	public func expenseUnits (expenseGroupId: UUID, page: Page) throws -> [ExpenseUnit.Default] {
		try expensePersistentRepository.loadExpenseGroupExpenses(expenseGroupId: expenseGroupId, page: page)
	}

	public func saveExpense (
		_ newExpense: Expense.New,
		superExpenseGroupId: UUID?,
		userGroupId: UUID,
		creatorId: UUID
	) throws {
		try expensePersistentRepository.saveExpense(
			newExpense,
			offlineStatus: .cached,
			cacheTimestamp: date(),
			updateTimestamp: nil,
			superExpenseGroupId: superExpenseGroupId,
			userGroupId: userGroupId,
			creatorId: creatorId
		)
	}

	public func saveExpenseGroup (
		_ newExpenseGroup: ExpenseGroup.New,
		superExpenseGroupId: UUID?,
		userGroupId: UUID,
		creatorId: UUID
	) throws {
		try expensePersistentRepository.saveExpenseGroup(
			newExpenseGroup,
			offlineStatus: .cached,
			cacheTimestamp: date(),
			updateTimestamp: nil,
			superExpenseGroupId: superExpenseGroupId,
			userGroupId: userGroupId,
			creatorId: creatorId
		)
	}

	public func createExpense (
		_ newExpense: Expense.New,
		superExpenseGroupId: UUID?,
		userGroupId: UUID
	) throws {
		guard let creatorId = currentUserService.user.value?.id else { throw NSError() } // TODO: throw error

		return try expensePersistentRepository.saveExpense(
			newExpense,
			offlineStatus: .offlineCreated,
			cacheTimestamp: nil,
			updateTimestamp: date(),
			superExpenseGroupId: superExpenseGroupId,
			userGroupId: userGroupId,
			creatorId: creatorId
		)
	}

	public func createExpenseGroup (
		_ newExpenseGroup: ExpenseGroup.New,
		superExpenseGroupId: UUID?,
		userGroupId: UUID
	) throws {
		guard let creatorId = currentUserService.user.value?.id else { throw NSError() } // TODO: throw error

		return try expensePersistentRepository.saveExpenseGroup(
			newExpenseGroup,
			offlineStatus: .offlineCreated,
			cacheTimestamp: nil,
			updateTimestamp: date(),
			superExpenseGroupId: superExpenseGroupId,
			userGroupId: userGroupId,
			creatorId: creatorId
		)
	}

	public func delete (id: UUID) throws {
		try expensePersistentRepository.delete(id: id)
	}
}

public enum ExpenseLocalServiceDependencyKey: DependencyKey {
	public static var liveValue: any PExpenseLocalService {
		ExpenseLocalService()
	}
}

public extension DependencyValues {
	var expenseLocalService: any PExpenseLocalService {
		get { self[ExpenseLocalServiceDependencyKey.self] }
		set { self[ExpenseLocalServiceDependencyKey.self] = newValue }
	}
}
