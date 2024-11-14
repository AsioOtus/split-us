import Foundation
import CoreData

@objc
class CurrentUserEntity: CacheableEntity {
	@discardableResult
	func set (
		id: UUID,
		username: String,
		email: String,
		name: String?,
		surname: String?,
		acronym: String?,
		cacheTimestamp: Date
	) -> Self {
		self.id = id
		self.username = username
		self.email = email
		self.name = name
		self.surname = surname
		self.acronym = acronym
		self.cacheTimestamp = cacheTimestamp

		return self
	}

	required init (context: NSManagedObjectContext) {
		super.init(context: context)
	}
}

extension CurrentUserEntity {
	@NSManaged public var id: UUID
	@NSManaged public var username: String
	@NSManaged public var email: String
	@NSManaged public var name: String?
	@NSManaged public var surname: String?
	@NSManaged public var acronym: String?
}
