import Foundation
import CoreData

@objc
class UserEntity: CacheableEntity {
	@discardableResult
	func set (
		id: UUID,
		username: String,
		name: String?,
		surname: String?,
		acronym: String?,
		isContact: Bool,
		cacheTimestamp: Date
	) -> Self {
		self.id = id
		self.username = username
		self.name = name
		self.surname = surname
		self.acronym = acronym
		self.isContact = isContact
		self.cacheTimestamp = cacheTimestamp

		return self
	}
	
	required init (context: NSManagedObjectContext) {
		super.init(context: context)
	}
}

extension UserEntity {
	@NSManaged public var id: UUID
	@NSManaged public var username: String
	@NSManaged public var name: String?
	@NSManaged public var surname: String?
	@NSManaged public var acronym: String?
	@NSManaged public var isContact: Bool

	@NSManaged public var borrowings: NSSet
	@NSManaged public var createdExpenses: NSSet
	@NSManaged public var creditedExpenses: NSSet
	@NSManaged public var userGroupMemberships: NSSet
}

// MARK: Created expenses
extension UserEntity {

	@objc(addCreatedExpensesObject:)
	@NSManaged public func addToCreatedExpenses(_ value: ExpenseEntity)

	@objc(removeCreatedExpensesObject:)
	@NSManaged public func removeFromCreatedExpenses(_ value: ExpenseEntity)

	@objc(addCreatedExpenses:)
	@NSManaged public func addToCreatedExpenses(_ values: NSSet)

	@objc(removeCreatedExpenses:)
	@NSManaged public func removeFromCreatedExpenses(_ values: NSSet)

}

// MARK: Credited expenses
extension UserEntity {

	@objc(addCreditedExpensesObject:)
	@NSManaged public func addToCreditedExpenses(_ value: ExpenseEntity)

	@objc(removeCreditedExpensesObject:)
	@NSManaged public func removeFromCreditedExpenses(_ value: ExpenseEntity)

	@objc(addCreditedExpenses:)
	@NSManaged public func addToCreditedExpenses(_ values: NSSet)

	@objc(removeCreditedExpenses:)
	@NSManaged public func removeFromCreditedExpenses(_ values: NSSet)

}

// MARK: User group memberhips
extension UserEntity {

	@objc(addUserGroupMembershipsObject:)
	@NSManaged public func addToUserGroupMemberships(_ value: UserGroupMemberEntity)

	@objc(removeUserGroupMembershipsObject:)
	@NSManaged public func removeFromUserGroupMemberships(_ value: UserGroupMemberEntity)

	@objc(addUserGroupMemberships:)
	@NSManaged public func addToUserGroupMemberships(_ values: NSSet)

	@objc(removeUserGroupMemberships:)
	@NSManaged public func removeFromUserGroupMemberships(_ values: NSSet)

}

extension UserEntity: Identifiable { }
