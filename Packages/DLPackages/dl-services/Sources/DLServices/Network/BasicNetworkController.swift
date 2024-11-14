import Dependencies
import NetworkUtil

struct BasicNetworkController: NetworkControllerDecorator {
	@Dependency(\.requestsConfiguration) var requestConfiguration

	private let _networkController: NetworkController = StandardNetworkController(configuration: .empty)
	var networkController: NetworkController {
		_networkController.replace(configuration: requestConfiguration.value)
	}
}
