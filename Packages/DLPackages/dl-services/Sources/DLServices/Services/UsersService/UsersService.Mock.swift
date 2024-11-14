import Dependencies
import DLModels
import Foundation
import XCTestDynamicOverlay

extension UsersService {
//	struct Mock: PUsersService {
//		var user: () async throws -> User = unimplemented()
//		var userDetails: (UUID) async throws -> User.Compact = unimplemented()
//		var users: (UUID, Page) async throws -> [User.Compact] = unimplemented()
//		var contacts: (_ page: Int, _ pageSize: Int) async throws -> [User.Compact] = unimplemented()
//		var contactsLocal: (_ page: Page) throws -> [User.Compact] = unimplemented()
//		var search: (String) async throws -> User.Contact? = unimplemented()
//		var addContact: (UUID) async throws -> Void = unimplemented()
//		var removeContact: (UUID) async throws -> Void = unimplemented()
//
//		func user () async throws -> User {
//			try await user()
//		}
//		
//		func userDetails (userId: UUID) async throws -> User.Compact {
//			try await userDetails(userId)
//		}
//		
//		func users (userGroupId: UUID, page: Page) async throws -> [User.Compact] {
//			try await users(userGroupId, page)
//		}
//
//		func contacts (page: Int, pageSize: Int) async throws -> [User.Compact] {
//			try await contacts(page, pageSize)
//		}
//
//		func contactsLocal (page: Page) throws -> [User.Compact] {
//			try contactsLocal(page)
//		}
//
//		func search (username: String) async throws -> User.Contact? {
//			try await search(username)
//		}
//		
//		func addContact (userId: UUID) async throws {
//			try await addContact(userId)
//		}
//		
//		func removeContact (userId: UUID) async throws {
//			try await removeContact(userId)
//		}
//	}
}

extension UsersServiceDependencyKey {
//	public static var testValue: PUsersService {
//		UsersService.Mock()
//	}
}
