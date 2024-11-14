import CoreData
import Dependencies
import DLModels
import Foundation

public protocol PExpensePersistentRepository {
	func loadUserGroupExpenses (
		userGroupId: UUID,
		page: Page
	) throws -> [ExpenseUnit.Default]

	func loadExpenseGroupExpenses (
		expenseGroupId: UUID,
		page: Page
	) throws -> [ExpenseUnit.Default]

	func loadExpense (
		id: UUID
	) throws -> Expense?

	func loadExpenseGroup (
		id: UUID
	) throws -> ExpenseGroup?

	func saveExpense (
		_ expense: Expense.New,
		offlineStatus: OfflineStatus,
		cacheTimestamp: Date?,
		updateTimestamp: Date?,
		superExpenseGroupId: UUID?,
		userGroupId: UUID,
		creatorId: UUID
	) throws

	func saveExpenseGroup (
		_ expenseGroup: ExpenseGroup.New,
		offlineStatus: OfflineStatus,
		cacheTimestamp: Date?,
		updateTimestamp: Date?,
		superExpenseGroupId: UUID?,
		userGroupId: UUID,
		creatorId: UUID
	) throws

	func cacheExpense (
		id: UUID,
		newId: UUID,
		cacheTimestamp: Date?
	) throws

	func delete (id: UUID) throws
}

public struct ExpensePersistentRepository {
	let userConverter = User.Compact.Converter.default
	let expenseConverter = Expense.Converter.default
	let expenseGroupConverter = ExpenseGroup.Converter.default

	let controller = CoreDataPersistentController.default
}

extension ExpensePersistentRepository: PExpensePersistentRepository {
	public func loadUserGroupExpenses (
		userGroupId: UUID,
		page: Page
	) throws -> [ExpenseUnit.Default] {
		let userGroup = try controller.find(UserGroupEntity.self, id: userGroupId)

		let expenses = try controller.load(
			ExpenseEntity.self,
			page: page.number,
			pageSize: page.size,
			predicate: .init(
				format: "ANY userGroup == %@ AND superExpenseGroup == nil",
				userGroup as CVarArg
			)
		)

		let expenseUnit: [ExpenseUnit.Default] = expenses.map { expenseEntity in
			expenseEntity.isGroup
			? .expenseGroup(expenseGroupConverter.convert(expenseEntity))
			: .expense(expenseConverter.convert(expenseEntity))
		}

		return expenseUnit
	}

	public func loadExpenseGroupExpenses (
		expenseGroupId: UUID,
		page: Page
	) throws -> [ExpenseUnit.Default] {
		let expenseGroup = try controller.find(ExpenseEntity.self, id: expenseGroupId)

		let expenses = try controller.load(
			ExpenseEntity.self,
			page: page.number,
			pageSize: page.size,
			predicate: .init(
				format: "ANY superExpenseGroup == %@",
				expenseGroup as CVarArg
			)
		)

		let expenseUnit: [ExpenseUnit.Default] = expenses.map { expenseEntity in
			expenseEntity.isGroup
			? .expenseGroup(expenseGroupConverter.convert(expenseEntity))
			: .expense(expenseConverter.convert(expenseEntity))
		}

		return expenseUnit
	}

	public func loadExpense (
		id: UUID
	) throws -> Expense? {
		guard let expenseEntity = try controller.load(ExpenseEntity.self, id: id) else { return nil }
		let expense = expenseConverter.convert(expenseEntity)
		return expense
	}

	public func loadExpenseGroup (
		id: UUID
	) throws -> ExpenseGroup? {
		guard let expenseEntity = try controller.load(ExpenseEntity.self, id: id) else { return nil }
		let expenseGroup = expenseGroupConverter.convert(expenseEntity)
		return expenseGroup
	}

	public func saveExpense (
		_ expense: Expense.New,
		offlineStatus: OfflineStatus,
		cacheTimestamp: Date?,
		updateTimestamp: Date?,
		superExpenseGroupId: UUID?,
		userGroupId: UUID,
		creatorId: UUID
	) throws {
		try controller.saveInBackgroundContext(ExpenseEntity.self, id: expense.id) { expenseEntity, context in
			let superExpenseGroup = try superExpenseGroupId.map {
				try controller.find(ExpenseEntity.self, id: $0, context: context)
			}

			guard superExpenseGroup == nil || superExpenseGroup?.isGroup == true
			else { throw PersistentError.integrityFault("Attempt to add subexpense to non-group expense.") }

			let userGroup = try controller.find(UserGroupEntity.self, id: userGroupId, context: context)
			let creditor = try expense.creditorId.map {
				try controller.find(UserEntity.self, id: $0, context: context)
			}
			let creator = try controller.find(UserEntity.self, id: creatorId, context: context)

			let expenseEntity = (expenseEntity ?? ExpenseEntity(context: context))
				.set(
					id: expense.id,
					name: expense.info.name,
					date: expense.info.date,
					note: expense.info.note,
					coordinate: expense.info.coordinate,
					amount: expense.totalAmountValue,
					currencyCode: expense.currencyId.uuidString,
					isGroup: false,
					offlineStatus: offlineStatus,
					creditor: creditor,
					superExpenseGroup: superExpenseGroup,
					userGroup: userGroup,
					creator: creator
				)
				.set(cacheTimestamp: cacheTimestamp)
				.set(updateTimestamp: cacheTimestamp == nil ? updateTimestamp : nil)

			for borrower in expense.borrowers {
				try saveExpenseBorrower(
					expenseBorrower: borrower,
					cacheTimestamp: cacheTimestamp,
					expense: expenseEntity,
					context: context
				)
			}
		}
	}

	public func saveExpenseGroup (
		_ expenseGroup: ExpenseGroup.New,
		offlineStatus: OfflineStatus,
		cacheTimestamp: Date?,
		updateTimestamp: Date?,
		superExpenseGroupId: UUID?,
		userGroupId: UUID,
		creatorId: UUID
	) throws {
		try controller.saveInBackgroundContext(ExpenseEntity.self, id: expenseGroup.id) { expenseGroupEntity, context in
			let superExpenseGroup = try superExpenseGroupId.map {
				try controller.find(ExpenseEntity.self, id: $0, context: context)
			}

			guard superExpenseGroup == nil || superExpenseGroup?.isGroup == true
			else { throw PersistentError.integrityFault("Attempt to add subexpense to non-group expense.") }

			let userGroup = try controller.find(UserGroupEntity.self, id: userGroupId, context: context)
			let creator = try controller.find(UserEntity.self, id: creatorId, context: context)

			(expenseGroupEntity ?? ExpenseEntity(context: context))
				.set(
					id: expenseGroup.id,
					name: expenseGroup.info.name,
					date: expenseGroup.info.date,
					note: expenseGroup.info.note,
					coordinate: expenseGroup.info.coordinate,
					amount: nil,
					currencyCode: "",
					isGroup: true,
					offlineStatus: offlineStatus,
					creditor: nil,
					superExpenseGroup: superExpenseGroup,
					userGroup: userGroup,
					creator: creator
				)
				.set(cacheTimestamp: cacheTimestamp)
				.set(updateTimestamp: updateTimestamp)
		}
	}

	public func cacheExpense (
		id: UUID,
		newId: UUID,
		cacheTimestamp: Date?
	) throws {
		try controller.saveInBackgroundContext { context in
			let expenseEntity = try controller.load(ExpenseEntity.self, id: id, context: context)
			expenseEntity?.id = newId
			expenseEntity?.offlineStatus = OfflineStatus.cached.rawValue
			expenseEntity?.cacheTimestamp = cacheTimestamp
			expenseEntity?.updateTimestamp = nil
		}
	}

	public func delete (id: UUID) throws {
		try controller.delete(ExpenseEntity.self, id: id)
	}
}

private extension ExpensePersistentRepository {
	@discardableResult
	func saveExpenseBorrower (
		expenseBorrower: Expense.New.Borrower,
		cacheTimestamp: Date?,
		expense: ExpenseEntity,
		context: NSManagedObjectContext
	) throws -> ExpenseBorrowerEntity {
		let borrower = try controller.find(UserEntity.self, id: expenseBorrower.id, context: context)

		let expenseBorrowerEntity = ExpenseBorrowerEntity(context: context)
			.set(
				id: expenseBorrower.id,
				amountValue: expenseBorrower.amountValue,
				isCompleted: expenseBorrower.isCompleted,
				borrower: borrower,
				expense: expense
			)
			.set(cacheTimestamp: cacheTimestamp)

		return expenseBorrowerEntity
	}
}

public enum ExpensePersistentRepositoryDependencyKey: DependencyKey {
	public static var liveValue: any PExpensePersistentRepository {
		ExpensePersistentRepository()
	}
}

public extension DependencyValues {
	var expensePersistentRepository: any PExpensePersistentRepository {
		get { self[ExpensePersistentRepositoryDependencyKey.self] }
		set { self[ExpensePersistentRepositoryDependencyKey.self] = newValue }
	}
}
