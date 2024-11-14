import CoreData
import DLModels
import Foundation

@objc
class ExpenseEntity: CacheableEntity {
	@discardableResult
	func set (
		id: UUID,
		name: String?,
		date: Date?,
		note: String?,
		coordinate: Coordinate?,
		amount: Int?,
		currencyCode: String,
		isGroup: Bool,
		offlineStatus: OfflineStatus,
		creditor: UserEntity?,
		superExpenseGroup: ExpenseEntity?,
		userGroup: UserGroupEntity,
		creator: UserEntity
	) -> Self {
		self.id = id
		self.name = name
		self.date = date
		self.note = note
		self.coordinate = coordinate?.rawValue
		self.amount = amount.map(NSNumber.init(value:))
		self.currencyCode = currencyCode
		self.isGroup = isGroup
		self.offlineStatus = offlineStatus.rawValue

		self.creditor = creditor
		self.creator = creator
		self.superExpenseGroup = superExpenseGroup
		self.userGroup = userGroup

		return self
	}

	@discardableResult
	func set (updateTimestamp: Date?) -> Self {
		self.updateTimestamp = updateTimestamp
		return self
	}

	required init (context: NSManagedObjectContext) {
		super.init(context: context)
	}
}

extension ExpenseEntity {
	static func fetchRequest() -> NSFetchRequest<ExpenseEntity> { .init(entityName: entityName) }

	@NSManaged var id: UUID
	@NSManaged var name: String?
	@NSManaged var date: Date?
	@NSManaged var note: String?
	@NSManaged var coordinate: String?
	@NSManaged var amount: NSNumber?
	@NSManaged var currencyCode: String
	@NSManaged var isGroup: Bool
	@NSManaged var offlineStatus: String
	@NSManaged var updateTimestamp: Date?

	@NSManaged var creditor: UserEntity?
	@NSManaged var creator: UserEntity
	@NSManaged var superExpenseGroup: ExpenseEntity?
	@NSManaged var userGroup: UserGroupEntity

	@NSManaged var subExpenses: NSSet
	@NSManaged var borrowers: NSSet

	var allBorrowers: [ExpenseBorrowerEntity] {
		borrowers.allObjects as! [ExpenseBorrowerEntity]
	}
	
	var allSubExpenseGroup: [ExpenseEntity] {
		subExpenses.allObjects as! [ExpenseEntity]
	}
}

// MARK: Sub expense group
extension ExpenseEntity {
	@objc(addSubExpenseGroupsObject:)
	@NSManaged func addToSubExpenseGroups (_ value: ExpenseEntity)

	@objc(removeSubExpenseGroupsObject:)
	@NSManaged func removeFromSubExpenseGroups (_ value: ExpenseEntity)

	@objc(addSubExpenseGroups:)
	@NSManaged func addToSubExpenseGroups (_ values: NSSet)

	@objc(removeSubExpenseGroups:)
	@NSManaged func removeFromSubExpenseGroups (_ values: NSSet)
}

// MARK: Borrowers
extension ExpenseEntity {

	@objc(addBorrowersObject:)
	@NSManaged func addToBorrowers (_ value: ExpenseBorrowerEntity)

	@objc(removeBorrowersObject:)
	@NSManaged func removeFromBorrowers (_ value: ExpenseBorrowerEntity)

	@objc(addBorrowers:)
	@NSManaged func addToBorrowers (_ values: NSSet)

	@objc(removeBorrowers:)
	@NSManaged func removeFromBorrowers (_ values: NSSet)

}
