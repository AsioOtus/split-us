import Dependencies
import Foundation
import DLNetwork
import DLModels
import Combine

public protocol PUserGroupsService {
	func create (name: String, users: [User.Compact]) async throws
	func userGroups () async throws -> [UserGroup]
	func transfers (userGroupId: UUID) async throws -> [TransferUnit]
	func users (userGroupId: UUID) async throws -> [User.Compact]
	func summary (userGroupId: UUID) async throws -> [UserSummary]
	func addUsersToUserGroup (userIds: [UUID], userGroupId: UUID) async throws
}

public struct UserGroupsService: PUserGroupsService {
	@Dependency(\.authenticatedNetworkController) var networkController
}

public extension UserGroupsService {
	func create (name: String, users: [User.Compact]) async throws {
		_ = try await networkController
			.send(
				Requests.CreateUserGroup(
					body: .init(
						userGroup: .init(
							name: name,
							userIds: users.map(\.id)
						)
					)
				)
			)
			.unfold()
	}
	
	func userGroups () async throws -> [UserGroup] {
		try await networkController
			.send(Requests.UserGroups())
			.unfold()
			.userGroups
			.map {
				.init(id: $0.id, name: $0.name)
			}
	}
	
	func transfers (userGroupId: UUID) async throws -> [TransferUnit] {
		try await networkController
			.send(Requests.UserGroupTransfers(userGroupId: userGroupId))
			.unfold()
			.transferUnits
	}
	
	func users (userGroupId: UUID) async throws -> [User.Compact] {
		try await networkController
			.send(Requests.UserGroupUsers(body: .init(userGroupId: userGroupId)))
			.unfold()
			.users
	}
	
	func summary (userGroupId: UUID) async throws -> [UserSummary] {
		try await networkController
			.send(Requests.UserGroupSummary(body: .init(userGroupId: userGroupId)))
			.unfold()
			.userSummaries
	}
	
	func addUsersToUserGroup (userIds: [UUID], userGroupId: UUID) async throws {
		_ = try await networkController
			.send(Requests.AddUserToUserGroup(body: .init(userGroupId: userGroupId, users: userIds)))
			.unfold()
	}
}

struct UserGroupsServiceDependencyKey: DependencyKey {
	public static var liveValue: PUserGroupsService {
		UserGroupsService()
	}
}

public extension DependencyValues {
	var userGroupsService: PUserGroupsService {
		get { self[UserGroupsServiceDependencyKey.self] }
		set { self[UserGroupsServiceDependencyKey.self] = newValue }
	}
}
