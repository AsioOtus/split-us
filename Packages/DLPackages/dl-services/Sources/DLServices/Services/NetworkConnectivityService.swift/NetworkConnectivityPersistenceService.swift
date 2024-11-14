import Dependencies
import DLModels
import Foundation

public protocol PNetworkConnectivityPersistenceService {
	func connectionState (_: ConnectionState)
	func connectionState () -> ConnectionState?
}

public struct NetworkConnectivityPersistenceService: PNetworkConnectivityPersistenceService {
	static let connectionStateKey = "sco.connectionState"

	let userDefaults: UserDefaults

	public init (userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
	}

	public func connectionState (_ connectionState: ConnectionState) {
		userDefaults.set(connectionState.rawValue, forKey: Self.connectionStateKey)
	}

	public func connectionState () -> ConnectionState? {
		let connectionStateRawValue = userDefaults.string(forKey: Self.connectionStateKey)
		let connectionState = connectionStateRawValue.flatMap(ConnectionState.init(rawValue:))
		return connectionState
	}
}

public enum NetworkConnectivityPersistenceServiceDependencyKey: DependencyKey {
	public static var liveValue: any PNetworkConnectivityPersistenceService {
		NetworkConnectivityPersistenceService(userDefaults: .standard)
	}
}

public extension DependencyValues {
	var networkConnectivityPersistenceService: any PNetworkConnectivityPersistenceService {
		get { self[NetworkConnectivityPersistenceServiceDependencyKey.self] }
		set { self[NetworkConnectivityPersistenceServiceDependencyKey.self] = newValue }
	}
}
