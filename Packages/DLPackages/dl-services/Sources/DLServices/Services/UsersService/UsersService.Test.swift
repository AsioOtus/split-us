import Dependencies
import DLModels
import Foundation
import XCTestDynamicOverlay

extension UsersService {
	struct Test: PUsersService {
		var user: () async throws -> User = unimplemented()
		var userDetails: (UUID) async throws -> User.Compact = unimplemented()
		var contacts: () async throws -> [User.Compact] = unimplemented()
		var search: (String) async throws -> User.ContactSearch? = unimplemented()
		var addContact: (UUID) async throws -> Void = unimplemented()
		var removeContact: (UUID) async throws -> Void = unimplemented()

		func user () async throws -> User {
			try await user()
		}
		
		func userDetails (userId: UUID) async throws -> User.Compact {
			try await userDetails(userId)
		}
		
		func contacts () async throws -> [User.Compact] {
			try await contacts()
		}
		
		func search (username: String) async throws -> User.ContactSearch? {
			try await search(username)
		}
		
		func addContact (userId: UUID) async throws {
			try await addContact(userId)
		}
		
		func removeContact (userId: UUID) async throws {
			try await removeContact(userId)
		}
	}
}

extension UsersServiceDependencyKey {
	public static var testValue: PUsersService {
		UsersService.Test()
	}
}
