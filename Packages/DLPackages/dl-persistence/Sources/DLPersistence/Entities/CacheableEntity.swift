import CoreData

@objc
class CacheableEntity: NSManagedObject, CoreDataEntity {
	@discardableResult
	func set (cacheTimestamp: Date?) -> Self {
		if let cacheTimestamp {
			self.cacheTimestamp = cacheTimestamp
		}

		return self
	}

	@objc
	private override init (entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
		super.init(entity: entity, insertInto: context)
	}

	required init (context: NSManagedObjectContext) {
		let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: context)!

		super.init(entity: entity, insertInto: context)
	}
}

extension CacheableEntity {
	@NSManaged var cacheTimestamp: Date?
}
