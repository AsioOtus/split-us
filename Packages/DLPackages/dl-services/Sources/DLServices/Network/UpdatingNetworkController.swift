import Dependencies
import NetworkUtil

struct UpdatingNetworkController: FullScaleNetworkControllerDecorator {
	@Dependency(\.requestsConfiguration) var requestConfiguration

	private let _networkController: FullScaleNetworkController = StandardNetworkController(configuration: .empty)
	var networkController: FullScaleNetworkController {
		_networkController.replaceConfiguration(requestConfiguration.value)
	}
}

public struct NetworkControllerDependecncyKey: DependencyKey {
	public static var liveValue: FullScaleNetworkController {
		UpdatingNetworkController()
	}
}

public extension DependencyValues {
	var networkController: FullScaleNetworkController {
		get { self[NetworkControllerDependecncyKey.self] }
		set { self[NetworkControllerDependecncyKey.self] = newValue }
	}
}
