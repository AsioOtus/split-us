import Combine
import Dependencies
import DLErrors
import DLModels
import Foundation
import Network
import NetworkUtil

public protocol PNetworkConnectivityService {
	var state: CurrentValueSubject<ConnectionState, Never> { get }

	func updateState (_ state: ConnectionState)
	@discardableResult
	func updateState (error: Error) -> ConnectionState
	func state (error: Error) -> ConnectionState
	func state (urlError: URLError) -> ConnectionState
	var offlineUrlErrorCodes: [URLError.Code] { get }
}

public class NetworkConnectivityService: PNetworkConnectivityService {
	public private(set) var state: CurrentValueSubject<ConnectionState, Never> = .init(.online)

	@Dependency(\.networkConnectivityPersistenceService) var networkConnectivityPersistenceService

	init () {
		let connectionState = networkConnectivityPersistenceService.connectionState() ?? .online
		state.send(connectionState)
	}

	public func updateState (_ state: ConnectionState) {
		self.state.send(state)
		networkConnectivityPersistenceService.connectionState(state)
	}

	public func updateState (error: Error) -> ConnectionState {
		let state = state(error: error)
		self.state.send(state)
		networkConnectivityPersistenceService.connectionState(state)
		return state
	}

	public func state (error: Error) -> ConnectionState {
		switch error {
		case is OfflineTriggerError:
			.offline

		case let urlError as URLError:
			state(urlError: urlError)

		case let controllerError as ControllerError:
			controllerError
				.networkError
				.map { state(urlError: $0.urlError) } ?? .online

		default:
			.online
		}
	}

	public func state (urlError: URLError) -> ConnectionState {
		offlineUrlErrorCodes.contains(urlError.code) ? .offline : .online
	}

	public let offlineUrlErrorCodes: [URLError.Code] = [
		.backgroundSessionInUseByAnotherProcess,
		.cannotFindHost,
		.cannotConnectToHost,
		.networkConnectionLost,
		.notConnectedToInternet,
		.secureConnectionFailed,
		.timedOut,
	]
}

public enum ConnectionStateServiceDependencyKey: DependencyKey {
	public static var liveValue: any PNetworkConnectivityService {
		NetworkConnectivityService()
	}
}

public extension DependencyValues {
	var networkConnectivityService: any PNetworkConnectivityService {
		get { self[ConnectionStateServiceDependencyKey.self] }
		set { self[ConnectionStateServiceDependencyKey.self] = newValue }
	}
}
