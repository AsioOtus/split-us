import Dependencies
import Foundation
import DLNetwork
import DLModels
import DLPersistence

public protocol PExpenseService {
	func expenses (userGroupId: UUID) async throws -> [ExpenseTree]
	func expenseUnits (userGroupId: UUID, page: Page) async throws -> [ExpenseUnit.Default]
	func expenseUnits (expenseGroupId: UUID, page: Page) async throws -> [ExpenseUnit.Default]

	func expense (id: UUID) async throws -> Expense
	func expenseGroup (id: UUID) async throws -> ExpenseGroup

	func createExpense (
		expense: Expense.New,
		superExpenseGroupId: UUID?,
		userGroupId: UUID
	) async throws -> Expense

	func createExpenseGroup (
		expenseGroup: ExpenseGroup.New,
		superExpenseGroupId: UUID?,
		userGroupId: UUID
	) async throws -> ExpenseGroup

	func createExpenseGroup (
		expenseGroupContainer: ExpenseGroup.New.Container,
		superExpenseGroupId: UUID?,
		userGroupId: UUID
	) async throws -> ExpenseGroup.Container

	func updateExpense (
		expense: Expense.Update
	) async throws -> Expense

	func updateExpenseGroup (
		expenseGroup: ExpenseGroup.Update
	) async throws -> ExpenseGroup

	func updateExpenseGroupInfo (
		expenseGroupInfo: ExpenseInfo,
		expenseGroupId: UUID
	) async throws -> ExpenseInfo

	func replaceExpense (
		expenseGroup: ExpenseGroup.New,
		expenseId: UUID
	) async throws -> ExpenseGroup

	func deleteExpense (
		id: UUID
	) async throws

	func deleteExpenseGroup (
		id: UUID
	) async throws
}

public struct ExpenseService: PExpenseService {
	@Dependency(\.currentUserService) var currentUserService
	@Dependency(\.authenticatedNetworkController) var networkController
	@Dependency(\.expenseLocalService) var expenseLocalService
	@Dependency(\.date) var date
}

public extension ExpenseService {
	func expenses (userGroupId: UUID) async throws -> [ExpenseTree] {
		try await networkController
			.send(Requests.UserGroupExpenses(userGroupId: userGroupId))
			.unfold()
			.expenseTrees
	}

	func expenseUnits (userGroupId: UUID, page: Page) async throws -> [ExpenseUnit.Default] {
		throw NSError()
	}

	func expenseUnits (expenseGroupId: UUID, page: Page) async throws -> [ExpenseUnit.Default] {
		throw NSError()
	}

	func expenseUnitsLocal (expenseGroupId: UUID, page: Page) throws -> [ExpenseUnit.Default] {
		throw NSError()
	}

	func expense (id: UUID) async throws -> Expense {
		throw NSError()
	}

	func expenseGroup (id: UUID) async throws -> ExpenseGroup {
		throw NSError()
	}

	func createExpense (
		expense: Expense.New,
		superExpenseGroupId: UUID?,
		userGroupId: UUID
	) async throws -> Expense {
		let newExpense = try await networkController
			.send(
				Requests.CreateExpense(
					expense: expense,
					superExpenseGroupId: superExpenseGroupId,
					userGroupId: userGroupId
				)
			)
			.unfold()
			.expense

		try expenseLocalService.saveExpense(
			newExpense.new,
			superExpenseGroupId: superExpenseGroupId,
			userGroupId: userGroupId,
			creatorId: newExpense.creator.id
		)

		return newExpense
	}

	func createExpenseGroup (
		expenseGroup: ExpenseGroup.New,
		superExpenseGroupId: UUID?,
		userGroupId: UUID
	) async throws -> ExpenseGroup {
		let newExpenseGroup = try await networkController
			.send(
				Requests.CreateExpenseGroup(
					expenseGroupContainer: .init(expenseGroup: expenseGroup, expenseTrees: []),
					superExpenseGroupId: superExpenseGroupId,
					userGroupId: userGroupId
				)
			)
			.unfold()
			.expenseGroupContainer
			.expenseGroup

		try expenseLocalService.saveExpenseGroup(
			newExpenseGroup.new,
			superExpenseGroupId: superExpenseGroupId,
			userGroupId: userGroupId,
			creatorId: newExpenseGroup.creator.id
		)

		return newExpenseGroup
	}

	func createExpenseGroup (
		expenseGroupContainer: ExpenseGroup.New.Container,
		superExpenseGroupId: UUID?,
		userGroupId: UUID
	) async throws -> ExpenseGroup.Container {
		try await networkController
			.send(
				Requests.CreateExpenseGroup(
					expenseGroupContainer: expenseGroupContainer,
					superExpenseGroupId: superExpenseGroupId,
					userGroupId: userGroupId
				)
			)
			.unfold()
			.expenseGroupContainer
	}

	func updateExpense (
		expense: Expense.Update
	) async throws  -> Expense {
		let expense = try await networkController
			.send(Requests.UpdateExpense(expense: expense))
			.unfold()
			.expense

		return expense
	}

	func updateExpenseGroup (
		expenseGroup: ExpenseGroup.Update
	) async throws -> ExpenseGroup {
		let info = try await networkController
			.send(Requests.UpdateExpenseGroupInfo(expenseGroupInfo: expenseGroup.info, expenseGroupId: expenseGroup.id))
			.unfold()
			.expenseInfo

		return .init(
			id: expenseGroup.id,
			info: info,
			offlineStatus: .cached,
			creator: currentUserService.user.value!.compact
		)
	}

	func updateExpenseGroupInfo (
		expenseGroupInfo: ExpenseInfo,
		expenseGroupId: UUID
	) async throws -> ExpenseInfo {
		try await networkController
			.send(
				Requests.UpdateExpenseGroupInfo(
					expenseGroupInfo: expenseGroupInfo,
					expenseGroupId: expenseGroupId
				)
			)
			.unfold()
			.expenseInfo
	}

	func replaceExpense (
		expenseGroup: ExpenseGroup.New,
		expenseId: UUID
	) async throws  -> ExpenseGroup {
		unimplemented()
	}

	func deleteExpense (id: UUID) async throws {
		_ = try await networkController
			.send(Requests.DeleteExpense(expenseId: id))
			.unfold()
	}

	func deleteExpenseGroup (id: UUID) async throws {
		_ = try await networkController
			.send(Requests.DeleteExpenseGroup(expenseGroupId: id))
			.unfold()
	}
}

extension ExpenseService: DependencyKey {
	public static var liveValue: PExpenseService {
		ExpenseService()
	}
}

public extension DependencyValues {
	var expenseService: PExpenseService {
		get { self[ExpenseService.self] }
		set { self[ExpenseService.self] = newValue }
	}
}
