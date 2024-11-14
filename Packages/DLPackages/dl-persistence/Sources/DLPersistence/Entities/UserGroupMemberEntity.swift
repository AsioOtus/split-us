import Foundation
import CoreData

@objc
class UserGroupMemberEntity: NSManagedObject, CoreDataEntity {
	@objc
	private override init (entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
		super.init(entity: entity, insertInto: context)
	}

	@discardableResult
	func set (
		role: String,
		user: UserEntity,
		userGroup: UserGroupEntity
	) -> Self {
		self.role = role
		self.user = user
		self.userGroup = userGroup

		return self
	}
}

extension UserGroupMemberEntity {
	static func fetchRequest() -> NSFetchRequest<UserGroupMemberEntity> { .init(entityName: entityName) }

	@NSManaged var role: String

	@NSManaged var user: UserEntity
	@NSManaged var userGroup: UserGroupEntity
}
