import Dependencies
import Foundation
import DLNetwork
import DLModels

public protocol PUsersService {
	func user () async throws -> User
	func userDetails (userId: UUID) async throws -> User.Compact
	func contacts () async throws -> [User.Compact]
	func search (username: String) async throws -> User.ContactSearch?
	func addContact (userId: UUID) async throws
	func removeContact (userId: UUID) async throws
}

public struct UsersService: PUsersService {
	@Dependency(\.authenticatedNetworkController) private var networkController

	public func user () async throws -> User {
		try await networkController.send(Requests.User())
			.unfold()
			.user
	}

	public func userDetails (userId: UUID) async throws -> User.Compact {
		try await networkController.send(Requests.UserDetails(body: .init(userId: userId)))
			.unfold()
			.user
	}

	public func contacts () async throws -> [User.Compact] {
		try await networkController.send(Requests.Contacts())
			.unfold()
			.users
	}

	public func search (username: String) async throws -> User.ContactSearch? {
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
