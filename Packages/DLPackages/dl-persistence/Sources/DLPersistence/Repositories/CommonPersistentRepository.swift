import Dependencies

public protocol PCommonPersistentRepository {
	func clear ()
}

public struct CommonPersistentRepository {
	let controller = CoreDataPersistentController.default
}

extension CommonPersistentRepository: PCommonPersistentRepository {
	public func clear () {
		controller.clear()
	}
}

public enum CommonPersistentRepositoryDependencyKey: DependencyKey {
	public static var liveValue: any PCommonPersistentRepository {
		CommonPersistentRepository()
	}
}

public extension DependencyValues {
	var commonPersistentRepository: any PCommonPersistentRepository {
		get { self[CommonPersistentRepositoryDependencyKey.self] }
		set { self[CommonPersistentRepositoryDependencyKey.self] = newValue }
	}
}
