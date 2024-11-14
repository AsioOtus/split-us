import Dependencies
import Foundation
import DLModels
import DLNetwork
import DLPersistence

public protocol PUsersService {
	func loadInitialUser () async throws -> User
	func user () async throws -> User
	func user (id: UUID) async throws -> User.Compact
	func contacts (page: Page) async throws -> [User.Compact]
	func userGroupMembers (userGroupId: UUID, page: Page) async throws -> [UserGroup.Member]
	func search (username: String) async throws -> User.Contact?
	func addContact (userId: UUID) async throws
	func removeContact (userId: UUID) async throws
}

public struct UsersService: PUsersService {
	@Dependency(\.currentUserService) var currentUserService
	@Dependency(\.authenticatedNetworkController) var networkController
	@Dependency(\.userLocalService) var userLocalService

	public func loadInitialUser () async throws -> User {
		let user = try await networkController.send(Requests.User())
			.unfold()
			.user

		userLocalService.clearIfUserNotMatch(user.id)
		try userLocalService.saveUser(user)
		try? userLocalService.saveUser(user.compact)
		currentUserService.set(user: user)

		return user
	}

	public func user () async throws -> User {
		let user = try await networkController.send(Requests.User())
			.unfold()
			.user

		try userLocalService.saveUser(user)
		try? userLocalService.saveUser(user.compact)

		return user
	}

	public func user (id: UUID) async throws -> User.Compact {
		let user = try await networkController.send(Requests.UserDetails(body: .init(userId: id)))
			.unfold()
			.user

		try? userLocalService.saveUser(user)

		return user
	}

	public func contacts (page: Page) async throws -> [User.Compact] {
		let contacts = try await networkController.send(Requests.Contacts())
			.unfold()
			.users

		try? userLocalService.saveUsers(contacts)

		return contacts
	}

	public func userGroupMembers (userGroupId: UUID, page: Page) async throws -> [UserGroup.Member] {
		let userGroupMembers = try await networkController
			.send(Requests.UserGroupUsers(body: .init(userGroupId: userGroupId)))
			.unfold()
			.users
			.map {
				UserGroup.Member(
					user: $0,
					role: .standard
				)
			}

		try userLocalService.saveUserGroupMembers(
			userGroupMembers,
			userGroupId: userGroupId
		)

		return userGroupMembers
	}

	public func search (username: String) async throws -> User.Contact? {
		try await networkController.send(Requests.ContactSearch(.init(username: username)))
			.unfold()
			.searchResult
	}

	public func addContact (userId: UUID) async throws {
		_ = try await networkController.send(Requests.AddContactRequest(userId: userId))
			.unfold()
	}

	public func removeContact (userId: UUID) async throws {
		_ = try await networkController.send(Requests.RemoveContactRequest(userId: userId))
			.unfold()
	}
}

enum UsersServiceDependencyKey: DependencyKey {
	public static var liveValue: PUsersService {
		UsersService()
	}
}

public extension DependencyValues {
	var usersService: PUsersService {
		get { self[UsersServiceDependencyKey.self] }
		set { self[UsersServiceDependencyKey.self] = newValue }
	}
}
