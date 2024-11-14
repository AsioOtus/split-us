import CoreData

@objc protocol CoreDataEntity where Self: NSManagedObject { }

extension CoreDataEntity {
	static var entityName: String {
		.init(describing: Self.self)
	}

	static func entityFetchRequest () -> NSFetchRequest<Self> {
		.init(entityName: entityName)
	}
}
