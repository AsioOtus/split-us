import Foundation
import DLModels
import DLModelsSamples

public extension PExpenseService where Self == ExpenseService.Stub {
	static var stub: Self { .init() }
}

extension ExpenseService {
	public struct Stub: PExpenseService {
		public func updateExpenseGroup(expenseGroup: ExpenseGroup.Update) async throws -> ExpenseGroup {
			fatalError()
		}
		
		public func expenses (userGroupId: UUID) async throws -> [ExpenseTree] {
			[
				.helsinki
			]
		}

		public func expenseUnits (userGroupId: UUID, page: Page) async throws -> [ExpenseUnit.Default] {
			[.expenseGroup(.helsinki)]
		}

		public func expenseUnits (expenseGroupId: UUID, page: Page) async throws -> [ExpenseUnit.Default] {
			[
				.expense(.beer),
				.expense(.iceCream),
				.expense(.longName),
				.expense(.train),
			]
		}

		public func expenseUnitsLocal (expenseGroupId: UUID, page: Page) throws -> [ExpenseUnit.Default] {
			[.expenseGroup(.helsinki)]
		}

		public func expenseLocal (id: UUID) throws -> Expense? {
			.beer
		}

		public func expenseGroupLocal (id: UUID) throws -> ExpenseGroup? {
			.helsinki
		}

		public func createExpenseLocal(_ newExpense: DLModels.Expense.New, superExpenseGroupId: UUID?, userGroupId: UUID) throws {

		}

		public func createExpenseGroupLocal(_ newExpenseGroup: DLModels.ExpenseGroup.New, superExpenseGroupId: UUID?, userGroupId: UUID) throws {
			
		}

		public func expense(id: UUID) async throws -> DLModels.Expense {
			.beer
		}

		public func expenseGroup(id: UUID) async throws -> DLModels.ExpenseGroup {
			.helsinki
		}

		public func createExpense (
			expense: Expense.New,
			superExpenseGroupId expenseGroupId: UUID?,
			userGroupId: UUID
		) async throws -> Expense {
			.beer
		}

		public func createExpenseGroup (
			expenseGroup: DLModels.ExpenseGroup.New,
			superExpenseGroupId: UUID?,
			userGroupId: UUID
		) async throws -> DLModels.ExpenseGroup {
			.helsinki
		}

		public func createExpenseGroup (
			expenseGroupContainer: ExpenseGroup.New.Container,
			superExpenseGroupId: UUID?,
			userGroupId: UUID
		) async throws -> ExpenseGroup.Container {
			.init(
				expenseGroup: .helsinki,
				expenseTrees: [
					.init(expense: .beer),
					.init(expense: .iceCream),
					.init(expense: .train),
					.init(expense: .longName),
				]
			)
		}
		
		public func updateExpense (
			expense: Expense.Update
		) async throws -> Expense {
			.init(
				id: expense.id,
				info: expense.info,
				totalAmount: .init(
					value: expense.totalAmountValue,
					currency: .init(
						id: expense.currencyId,
						code: "eur"
					)
				),
				creditor: expense.creditorId.map {
					.init(
						id: $0,
						username: "ostap",
						name: nil,
						surname: nil
					)
				},
				borrowers: expense.borrowers.map {
					.init(
						user: .init(
							id: $0.userId,
							username: "ostap",
							name: nil,
							surname: nil
						),
						amountValue: $0.amountValue,
						isCompleted: $0.isCompleted
					)
				},
				offlineStatus: .cached,
				creator: .ostap
			)
		}
		
		public func updateExpenseGroupInfo (
			expenseGroupInfo: ExpenseInfo,
			expenseGroupId: UUID
		) async throws -> ExpenseInfo {
			.init(
				name: expenseGroupInfo.name,
				note: expenseGroupInfo.note,
				date: expenseGroupInfo.date,
				coordinate: expenseGroupInfo.coordinate
			)
		}
		
		public func replaceExpense (
			expenseGroup: ExpenseGroup.New,
			expenseId: UUID
		) async throws -> ExpenseGroup {
			.helsinki
		}
		
		public func deleteExpense (
			id: UUID
		) async throws { }

		public func deleteExpenseGroup (
			id: UUID
		) async throws { }
	}
}
