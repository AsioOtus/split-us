import Combine
import Dependencies
import DLNetwork
import Foundation

public protocol PNetworkConnectivityRefreshService {
	func refresh () async throws
}

public class NetworkConnectivityRefreshService: PNetworkConnectivityRefreshService {
	@Dependency(\.basicNetworkController) var basicNetworkController
	@Dependency(\.authenticatedNetworkController) var authenticatedNetworkController
	@Dependency(\.networkConnectivityService) var networkConnectivityService

	public func refresh () async throws {
		// TODO
//		let response = try await basicNetworkController.send(Requests.HealthPing())
//		let state: ConnectionState = response.httpUrlResponse?.statusCode == 200
//			? .online
//			: .offline
//
//		networkConnectivityService.updateState(state)

		_ = try await authenticatedNetworkController.send(Requests.User())
	}
}

public enum NetworkConnectivityRefreshServiceDependencyKey: DependencyKey {
	public static var liveValue: any PNetworkConnectivityRefreshService {
		NetworkConnectivityRefreshService()
	}
}

public extension DependencyValues {
	var networkConnectivityRefreshService: any PNetworkConnectivityRefreshService {
		get { self[NetworkConnectivityRefreshServiceDependencyKey.self] }
		set { self[NetworkConnectivityRefreshServiceDependencyKey.self] = newValue }
	}
}
