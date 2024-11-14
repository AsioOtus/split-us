import Dependencies
import Foundation
import NetworkUtil

public struct UpdatingNetworkControllerDependencyKey: DependencyKey {
	public static var liveValue: NetworkController {
		BasicNetworkController()
	}
}

public extension DependencyValues {
	var basicNetworkController: NetworkController {
		get { self[UpdatingNetworkControllerDependencyKey.self] }
		set { self[UpdatingNetworkControllerDependencyKey.self] = newValue }
	}
}

public struct NetworkControllerDependencyKey: DependencyKey {
	public static var liveValue: NetworkController {
		@Dependency(\.basicNetworkController) var basicNetworkController

		return basicNetworkController
			.offline()
			.networkConnectivity()
	}
}

public extension DependencyValues {
	var networkController: NetworkController {
		get { self[NetworkControllerDependencyKey.self] }
		set { self[NetworkControllerDependencyKey.self] = newValue }
	}
}

public struct AuthenticatedNetworkControllerDependencyKey: DependencyKey {
	public static var liveValue: NetworkController {
		@Dependency(\.networkController) var networkController
		return networkController.authenticated()
	}
}

public extension DependencyValues {
	var authenticatedNetworkController: NetworkController {
		get { self[AuthenticatedNetworkControllerDependencyKey.self] }
		set { self[AuthenticatedNetworkControllerDependencyKey.self] = newValue }
	}
}
