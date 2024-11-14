import Dependencies
import DLModels

public protocol PUserGroupLocalService {
	func loadUserGroups (page: Page) throws -> [UserGroup]
	func saveUserGroups (_ userGroups: [UserGroup]) throws
}

public struct UserGroupLocalService: PUserGroupLocalService {
	@Dependency(\.userGroupPersistentRepository) var userGroupPersistentRepository

	public func loadUserGroups (page: Page) throws -> [UserGroup] {
		try userGroupPersistentRepository.loadUserGroups(page: page)
	}

	public func saveUserGroups (_ userGroups: [UserGroup]) throws {
		try userGroupPersistentRepository.saveUserGroups(userGroups)
	}
}

public enum UserGroupLocalServiceDependencyKey: DependencyKey {
	public static var liveValue: any PUserGroupLocalService {
		UserGroupLocalService()
	}
}

public extension DependencyValues {
	var userGroupLocalService: any PUserGroupLocalService {
		get { self[UserGroupLocalServiceDependencyKey.self] }
		set { self[UserGroupLocalServiceDependencyKey.self] = newValue }
	}
}
