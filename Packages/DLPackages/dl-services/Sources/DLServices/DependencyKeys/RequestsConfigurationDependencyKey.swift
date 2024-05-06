import Dependencies
import Multitool
import NetworkUtil

public struct RequestsConfigurationDependencyKey: DependencyKey {
	public static var liveValue: Object<URLRequestConfiguration> = .init(.init(address: "localhost"))
}

public extension DependencyValues {
	var requestsConfiguration: Object<URLRequestConfiguration> {
		get { self[RequestsConfigurationDependencyKey.self] }
		set { self[RequestsConfigurationDependencyKey.self] = newValue }
	}
}
