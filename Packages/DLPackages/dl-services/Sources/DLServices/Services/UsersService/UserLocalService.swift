import Dependencies
import DLModels
import Foundation

public protocol PUserLocalService {
	func loadInitialUser () throws -> User?
	func user () throws -> User?
	func user (id: UUID) throws -> User.Compact?
	func contacts (page: Page) throws -> [User.Compact]
	func userGroupMembers (userGroupId: UUID, page: Page) throws -> [UserGroup.Member]

	func saveUser (_ user: User) throws
	func saveUser (_ user: User.Compact) throws
	func saveUsers (_ users: [User.Compact]) throws
	func saveUserGroupMembers (_ members: [UserGroup.Member], userGroupId: UUID) throws

	func clearIfUserNotMatch (_ userId: UUID)
}

public struct UserLocalService: PUserLocalService {
	@Dependency(\.currentUserService) var currentUserService
	@Dependency(\.localAuthorizationService) var localAuthorizationService
	@Dependency(\.localPersistenceService) var localPersistenceService
	@Dependency(\.userPersistentRepository) var userPersistentRepository
	@Dependency(\.tokensValidationService) var tokensValidationService

	public func loadInitialUser () throws -> User? {
		guard
			let tokenPair = try? localAuthorizationService.savedTokenPair(),
			let userId = tokensValidationService.userId(from: tokenPair)
		else { return nil }

		clearIfUserNotMatch(userId)

		if let user = try? userPersistentRepository.loadUser() {
			currentUserService.set(user: user)
			return user
		} else {
			return nil
		}
	}

	public func user () throws -> User? {
		try userPersistentRepository.loadUser()
	}

	public func user (id: UUID) throws -> User.Compact? {
		try userPersistentRepository.loadUser(id: id)
	}
	
	public func contacts (page: Page) throws -> [User.Compact] {
		try userPersistentRepository.loadContacts(page: page)
	}

	public func userGroupMembers (userGroupId: UUID, page: Page) throws -> [UserGroup.Member] {
		try userPersistentRepository.loadUserGroupMembers(userGroupId: userGroupId, page: page)
	}

	public func saveUser (_ user: User) throws {
		try userPersistentRepository.saveUser(user)
	}

	public func saveUser (_ user: User.Compact) throws {
		try userPersistentRepository.saveUser(user)
	}

	public func saveUsers (_ users: [User.Compact]) throws {
		try userPersistentRepository.saveUsers(users)
	}

	public func saveUserGroupMembers (_ members: [UserGroup.Member], userGroupId: UUID) throws {
		try userPersistentRepository.saveUserGroupMembers(members, userGroupId: userGroupId)
	}

	public func clearIfUserNotMatch (_ userId: UUID) {
		guard let user = try? user(), user.id != userId else { return }

		localPersistenceService.clear()
	}
}

public enum UserLocalServiceDependencyKey: DependencyKey {
	public static var liveValue: any PUserLocalService {
		UserLocalService()
	}
}

public extension DependencyValues {
	var userLocalService: any PUserLocalService {
		get { self[UserLocalServiceDependencyKey.self] }
		set { self[UserLocalServiceDependencyKey.self] = newValue }
	}
}
