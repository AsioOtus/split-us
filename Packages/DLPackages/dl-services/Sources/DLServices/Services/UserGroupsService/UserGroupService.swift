import Dependencies
import Foundation
import DLNetwork
import DLModels
import DLModelsSamples
import Combine

public protocol PUserGroupsService {
	func create (name: String, users: [User.Compact]) async throws
	func userGroups () async throws -> [UserGroup]
	func summary (userGroupId: UUID) async throws -> [UserSummary]
	func addUsersToUserGroup (userIds: [UUID], userGroupId: UUID) async throws
}

public struct UserGroupsService: PUserGroupsService {
	@Dependency(\.authenticatedNetworkController) var networkController
	@Dependency(\.userGroupLocalService) var userGroupLocalService
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
		let userGroups = try await networkController
			.send(Requests.UserGroups())
			.unfold()
			.userGroups
			.map {
				UserGroup(
					id: $0.id,
					name: $0.name,
					defaultCurrency: .init(id: .create(1), code: "eur")
				)
			}

		try? userGroupLocalService.saveUserGroups(userGroups)

		return userGroups
	}
	
	func summary (userGroupId: UUID) async throws -> [UserSummary] {
		UserSummary.all
//		try await networkController
//			.send(Requests.UserGroupSummary(body: .init(userGroupId: userGroupId)))
//			.unfold()
//			.userSummaries
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
