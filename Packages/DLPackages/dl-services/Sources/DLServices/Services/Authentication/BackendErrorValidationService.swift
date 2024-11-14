import Dependencies
import NetworkUtil

public protocol PBackendErrorValidationService {
	func isAuthenticationError (_ error: Error) -> Bool
}

public struct BackendErrorValidationService: PBackendErrorValidationService {
	public func isAuthenticationError (_ error: Error) -> Bool {
		switch error {
		default:
			false
		}
	}
}

public enum BackendErrorValidationServiceDependencyKey: DependencyKey {
	public static var liveValue: any PBackendErrorValidationService {
		BackendErrorValidationService()
	}
}

public extension DependencyValues {
	var backendErrorValidationService: any PBackendErrorValidationService {
		get { self[BackendErrorValidationServiceDependencyKey.self] }
		set { self[BackendErrorValidationServiceDependencyKey.self] = newValue }
	}
}
