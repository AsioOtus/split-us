import Foundation
import CoreData

@objc
class UserGroupEntity: CacheableEntity {
	@discardableResult
	func set (
		id: UUID,
		name: String,
		cacheTimestamp: Date
	) -> Self {
		self.id = id
		self.name = name
		self.cacheTimestamp = cacheTimestamp

		return self
	}

	required init (context: NSManagedObjectContext) {
		super.init(context: context)
	}
}

extension UserGroupEntity {
	static func fetchRequest() -> NSFetchRequest<UserGroupEntity> { .init(entityName: entityName) }

	@NSManaged var id: UUID
	@NSManaged var name: String

	@NSManaged var expenses: NSSet
	@NSManaged var members: NSSet
}
