import Foundation
import CoreData

@objc
class ExpenseBorrowerEntity: CacheableEntity {
	@discardableResult
	func set (
		id: UUID?,
		amountValue: Int?,
		isCompleted: Bool,
		borrower: UserEntity,
		expense: ExpenseEntity?
	) -> Self {
		self.id = id
		self.amountValue = amountValue.map(NSNumber.init(value:))
		self.isCompleted = isCompleted
		self.borrower = borrower
		self.expense = expense

		return self
	}

	required init (context: NSManagedObjectContext) {
		super.init(context: context)
	}
}

extension ExpenseBorrowerEntity {
	@NSManaged var id: UUID?
	@NSManaged var amountValue: NSNumber?
	@NSManaged var isCompleted: Bool
	@NSManaged var borrower: UserEntity
	@NSManaged var expense: ExpenseEntity?
}
