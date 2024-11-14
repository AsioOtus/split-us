import Dependencies
import DLModels
import Foundation

public protocol PUserPersistentRepository {
	func loadUser () throws -> User?
	func loadUser (id: UUID) throws -> User.Compact?
	func loadContacts (page: Page) throws -> [User.Compact]
	func loadUserGroupMembers (userGroupId: UUID, page: Page) throws -> [UserGroup.Member]
	func saveUser (_ user: User) throws
	func saveUser (_ user: User.Compact) throws
	func saveUsers (_ users: [User.Compact]) throws
	func saveUserGroupMembers (_ members: [UserGroup.Member], userGroupId: UUID) throws
}

public struct UserPersistentRepository {
	let userConverter = User.Compact.Converter.default

	let controller = CoreDataPersistentController.default
}

extension UserPersistentRepository: PUserPersistentRepository {
	public func loadUser () throws -> User? {
		try controller.load(
			CurrentUserEntity.self,
			page: nil,
			pageSize: nil,
			predicate: nil
		)
		.map {
			.init(
				id: $0.id,
				username: $0.username,
				email: $0.email,
				name: $0.name,
				surname: $0.surname
			)
		}
		.first
	}

	public func loadUser (id: UUID) throws -> User.Compact? {
		try controller
			.load(UserEntity.self, id: id)
			.map(userConverter.convert)
	}

	public func loadContacts (page: Page) throws -> [User.Compact] {
		try controller
			.load(
				UserEntity.self,
				page: page.number,
				pageSize: page.size,
				predicate: .init(format: "isContact == true"),
				sortDescriptors: [
					.init(keyPath: \UserEntity.surname, ascending: true),
					.init(keyPath: \UserEntity.name, ascending: true),
					.init(keyPath: \UserEntity.username, ascending: true),
				]
			)
			.map(userConverter.convert)
	}

	public func loadUserGroupMembers (userGroupId: UUID, page: Page) throws -> [UserGroup.Member] {
		let userGroup = try controller.find(UserGroupEntity.self, id: userGroupId)
		let userGroupMembers = try controller
			.load(
				UserEntity.self,
				page: page.number,
				pageSize: page.size,
				predicate: .init(
					format: "ANY userGroupMemberships.userGroup.id == %@",
					userGroup.id as CVarArg
				),
				sortDescriptors: [
					.init(keyPath: \UserEntity.surname, ascending: true),
					.init(keyPath: \UserEntity.name, ascending: true),
					.init(keyPath: \UserEntity.username, ascending: true),
				]
			)
			.map(userConverter.convert)
			.map {
				UserGroup.Member(
					user: $0,
					role: .standard
				)
			}

		return userGroupMembers
	}

	public func saveUser (_ user: User) throws {
		try controller.saveInBackgroundContext(CurrentUserEntity.self, id: user.id) { userEntity, context in
			let userEntity = userEntity ?? .init(context: context)
			userEntity.set(
				id: user.id,
				username: user.username,
				email: user.email,
				name: user.name,
				surname: user.surname,
				acronym: "",
				cacheTimestamp: .init()
			)
		}
	}

	public func saveUser (_ user: User.Compact) throws {
		try controller.saveInBackgroundContext(UserEntity.self, id: user.id) { userEntity, context in
			userConverter.convert(
				user,
				cacheTimestamp: .init(),
				entity: userEntity ?? .init(context: context)
			)
		}
	}

	public func saveUsers (_ users: [User.Compact]) throws {
		try controller.saveInBackgroundContext { context in
			try users.forEach { user in
				let userEntity = try controller.load(UserEntity.self, id: user.id, context: context)

				userConverter.convert(
					user,
					cacheTimestamp: .init(),
					entity: userEntity ?? .init(context: context)
				)
			}
		}
	}

	public func saveUserGroupMembers (_ members: [UserGroup.Member], userGroupId: UUID) throws {
		do {
			try controller.saveInBackgroundContext { context in
				let userGroup = try controller.find(UserGroupEntity.self, id: userGroupId, context: context)

				try members.forEach { member in
					let userEntity = try controller.load(UserEntity.self, id: member.user.id, context: context) ?? .init(context: context)

					UserGroupMemberEntity(context: context)
						.set(
							role: member.role.rawValue,
							user: userConverter.convert(
								member.user,
								cacheTimestamp: .init(),
								entity: userEntity
							),
							userGroup: userGroup
						)
				}
			}
		} catch {
			print(error)
			throw error
		}
	}
}

public enum UserPersistentRepositoryDependencyKey: DependencyKey {
	public static var liveValue: any PUserPersistentRepository {
		UserPersistentRepository()
	}
}

public extension DependencyValues {
	var userPersistentRepository: any PUserPersistentRepository {
		get { self[UserPersistentRepositoryDependencyKey.self] }
		set { self[UserPersistentRepositoryDependencyKey.self] = newValue }
	}
}
