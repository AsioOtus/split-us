import Dependencies
import DLModels
import DLModelsSamples
import Foundation

public protocol PUserGroupPersistentRepository {
	func loadUserGroups (page: Page) throws -> [UserGroup]
	func loadUserGroup (_ id: UUID) throws -> UserGroup?
	func saveUserGroup (_ userGroup: UserGroup) throws
	func saveUserGroups (_ userGroups: [UserGroup]) throws
}

public struct UserGroupPersistentRepository {
	let userConverter = User.Compact.Converter.default

	let controller = CoreDataPersistentController.default
}

extension UserGroupPersistentRepository: PUserGroupPersistentRepository {
	public func loadUserGroups (page: Page) throws -> [UserGroup] {
		try controller
			.load(UserGroupEntity.self, page: page.number, pageSize: page.size, predicate: nil)
			.map {
				.init(
					id: $0.id,
					name: $0.name,
					defaultCurrency: .eur
				)
			}
	}

	public func loadUserGroup (_ id: UUID) throws -> UserGroup? {
		try controller
			.load(UserGroupEntity.self, id: id)
			.map {
				.init(
					id: $0.id,
					name: $0.name,
					defaultCurrency: .eur
				)
			}
	}

	public func saveUserGroup (_ userGroup: UserGroup) throws {
		try controller.saveInBackgroundContext(UserGroupEntity.self, id: userGroup.id) { userGroupEntity, context in
			(userGroupEntity ?? UserGroupEntity(context: context))
				.set(
					id: userGroup.id,
					name: userGroup.name,
					cacheTimestamp: .init()
				)
		}
	}

	public func saveUserGroups (_ userGroups: [UserGroup]) throws {
		try controller.saveInBackgroundContext { context in
			try userGroups.forEach { userGroup in
				let userGroupEntity = try controller.load(UserGroupEntity.self, id: userGroup.id, context: context)

				(userGroupEntity ?? UserGroupEntity(context: context))
					.set(
						id: userGroup.id,
						name: userGroup.name,
						cacheTimestamp: .init()
					)
			}
		}
	}
}

public enum UserGroupPersistentRepositoryDependencyKey: DependencyKey {
	public static var liveValue: any PUserGroupPersistentRepository {
		UserGroupPersistentRepository()
	}
}

public extension DependencyValues {
	var userGroupPersistentRepository: any PUserGroupPersistentRepository {
		get { self[UserGroupPersistentRepositoryDependencyKey.self] }
		set { self[UserGroupPersistentRepositoryDependencyKey.self] = newValue }
	}
}
