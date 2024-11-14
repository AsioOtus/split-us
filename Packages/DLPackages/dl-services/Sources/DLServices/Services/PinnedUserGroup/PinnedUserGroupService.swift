import Dependencies
import Foundation

public protocol PPersistentPinnedUserGroupService {
	func pin (userGroupId: UUID)
	func pinnedUserGroupId () -> UUID?
	func unpin ()
}

public struct PersistentPinnedUserGroupService: PPersistentPinnedUserGroupService {
	static let pinnedUserGroupUserDefaultsKey = "sco.pinnedUserGroupId"

	let userDefaults: UserDefaults

	public init (userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
	}

	public func pin (userGroupId: UUID) {
		userDefaults.setValue(userGroupId.description, forKey: PersistentPinnedUserGroupService.pinnedUserGroupUserDefaultsKey)
	}
	
	public func pinnedUserGroupId () -> UUID? {
		let uuidString = userDefaults.string(forKey: PersistentPinnedUserGroupService.pinnedUserGroupUserDefaultsKey)
		let uuid = uuidString.flatMap(UUID.init(uuidString:))
		return uuid
	}

	public func unpin () {
		userDefaults.removeObject(forKey: PersistentPinnedUserGroupService.pinnedUserGroupUserDefaultsKey)
	}
}

public enum PinnedUserGroupServiceDependencyKey: DependencyKey {
	public static let liveValue: any PPersistentPinnedUserGroupService = PersistentPinnedUserGroupService(userDefaults: .standard)
}

public extension DependencyValues {
	var persistentPinnedUserGroupService: any PPersistentPinnedUserGroupService {
		get { self[PinnedUserGroupServiceDependencyKey.self] }
		set { self[PinnedUserGroupServiceDependencyKey.self] = newValue }
	}
}
