import Dependencies
import Foundation

public protocol PLocalPersistenceService {
	func clear ()
}

public struct LocalPersistenceService: PLocalPersistenceService {
	@Dependency(\.commonPersistentRepository) var commonPersistentRepository

	public func clear () {
		commonPersistentRepository.clear()
	}
}

public enum LocalPersistenceServiceDependencyKey: DependencyKey {
	public static var liveValue: any PLocalPersistenceService {
		LocalPersistenceService()
	}
}

public extension DependencyValues {
	var localPersistenceService: any PLocalPersistenceService {
		get { self[LocalPersistenceServiceDependencyKey.self] }
		set { self[LocalPersistenceServiceDependencyKey.self] = newValue }
	}
}
