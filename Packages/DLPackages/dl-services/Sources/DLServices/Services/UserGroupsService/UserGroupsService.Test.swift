import Dependencies
import DLModels
import Foundation
import XCTestDynamicOverlay

extension UserGroupsService {
	struct Test: PUserGroupsService {
		var create: (String, [User.Compact]) async throws -> Void = unimplemented()
		var userGroups: () async throws -> [UserGroup] = unimplemented()
		var transfers: (UUID) async throws -> [TransferUnit] = unimplemented()
		var users: (UUID) async throws -> [User.Compact] = unimplemented()
		var summary: (UUID) async throws -> [UserSummary] = unimplemented()
		var addUsersToUserGroup: ([UUID], UUID) async throws -> Void = unimplemented()

		func create (name: String, users: [DLModels.User.Compact]) async throws {
			try await create(name, users)
		}
		
		func userGroups() async throws -> [DLModels.UserGroup] {
			try await userGroups()
		}
		
		func transfers(userGroupId: UUID) async throws -> [DLModels.TransferUnit] {
			try await transfers(userGroupId)
		}
		
		func users(userGroupId: UUID) async throws -> [DLModels.User.Compact] {
			try await users(userGroupId)
		}
		
		func summary(userGroupId: UUID) async throws -> [DLModels.UserSummary] {
			try await summary(userGroupId)
		}
		
		func addUsersToUserGroup(userIds: [UUID], userGroupId: UUID) async throws {
			try await addUsersToUserGroup(userIds, userGroupId)
		}
	}
}

extension UserGroupsServiceDependencyKey {
	public static var testValue: PUserGroupsService {
		UserGroupsService.Test()
	}
}
