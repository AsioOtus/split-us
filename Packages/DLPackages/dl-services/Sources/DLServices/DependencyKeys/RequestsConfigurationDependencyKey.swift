import Dependencies
import Multitool
import NetworkUtil

public struct RequestsConfigurationDependencyKey: DependencyKey {
	public static var liveValue: Reference<RequestConfiguration> = .init(.empty)
}

public extension DependencyValues {
	var requestsConfiguration: Reference<RequestConfiguration> {
		get { self[RequestsConfigurationDependencyKey.self] }
		set { self[RequestsConfigurationDependencyKey.self] = newValue }
	}
}
