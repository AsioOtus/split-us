import ComposableArchitecture
import Dependencies
import DLModels
import DLErrors
import NetworkUtil
import Multitool
import MultitoolFormatters
import OSLog
import ScreenLogin
import ScreenRegistration

extension Root {
	@Reducer
	struct Reducer: ComposableArchitecture.Reducer {
		typealias State = Root.State
		typealias Action = Root.Action
		
		@Dependency(\.analyticsService) var analyticsService
		@Dependency(\.authorizationService) var authorizationService
		@Dependency(\.currentUserService) var currentUserService
		@Dependency(\.localAuthorizationService) var localAuthorizationService
		@Dependency(\.localPersistenceService) var localPersistenceService
		@Dependency(\.logoutEventChannel) var logoutEventChannel
		@Dependency(\.networkController) var networkController
		@Dependency(\.networkConnectivityService) var networkConnectivityService
		@Dependency(\.tokensValidationService) var tokensValidationService
		@Dependency(\.userLocalService) var userLocalService
		@Dependency(\.usersService) var usersService

		var body: some ReducerOf<Self> {
			Reduce { state, action in
				switch action {
				case .initialize: return initialize(&state)

				case .onUserLoadingSuccess(let user): onUserLoadingSuccess(user, &state)
				case .onUserLoadingFailure(let error): onUserLoadingFailure(error, &state)
				case .onLogout: return onLogout(&state)

				case .login(.onLoginRequestLoaded(.successful)): onLogin(&state)
				case .login(.onRegistrationButtonTap): onRegistrationButtonTap(&state)

				case .registration(.onRegistrationLoaded(.success)): onRegistration(&state)
				case .registration(.onLogInButtonTap): onLogInButtonTap(&state)

				default: break
				}

				return .none
			}
			.ifCaseLet(\.main, action: \.main) {
				Main.Reducer()
			}
			.ifCaseLet(\.login, action: \.login) {
				Login.Reducer()
			}
			.ifCaseLet(\.registration, action: \.registration) {
				Registration.Reducer()
			}
		}
	}
}

private extension Root.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		if let user = try? userLocalService.loadInitialUser() {
			signInOffline(user, &state)
		}

		return .merge(
			subscribeLogout(),
			subscribeNetworkLogs(),
			loadUser(&state)
		)
	}

	func onUserLoadingSuccess (_ user: User, _ state: inout State) {
		guard state.isSplash else { return }
		state = .main(.init())
		analyticsService.log(.login(mode: .silent, username: user.username))
	}

	func onUserLoadingFailure (_ error: Error, _ state: inout State) {
		guard state.isSplash else { return }
		state = .login(.init())
	}

	func onLogout (_ state: inout Root.Reducer.State) -> Effect<Action> {
		defer {
			localAuthorizationService.deleteTokenPair()
			state = .login(.init())
			analyticsService.log(.logout(username: currentUserService.user.value?.username ?? ""))
			currentUserService.delete()
		}

		guard let tokenPair = try? localAuthorizationService.savedTokenPair()
		else { return .none }

		return .run { _ in
			await authorizationService.deauthenticate(tokenPair: tokenPair)
		}
	}

	func onLogin (_ state: inout State) {
		signIn(&state)
	}

	func onRegistration (_ state: inout State) {
		signIn(&state)
	}

	func onRegistrationButtonTap (_ state: inout State) {
		state = .registration(.init())
	}

	func onLogInButtonTap (_ state: inout State) {
		state = .login(.init())
	}
}

private extension Root.Reducer {
	func loadUser (_ state: inout State) -> Effect<Action> {
		guard (try? localAuthorizationService.savedTokenPair()) != nil
		else {
			localAuthorizationService.deleteTokenPair()
			state = .login(.init())
			return .none
		}

		return .run { send in
			let user = try await usersService.loadInitialUser()
			await send(.onUserLoadingSuccess(user))
		} catch: { error, send in
			await send(.onUserLoadingFailure(error))
		}
	}

	func subscribeLogout () -> Effect<Action> {
		.run { send in
			for await _ in logoutEventChannel {
				await send(.onLogout)
			}
		}
	}

	func subscribeNetworkLogs () -> Effect<Action> {
		.run { _ in
			for await logRecord in networkController.logs {
				logNetworkEvent(logRecord)
			}
		}
	}

	func signIn (_ state: inout State) {
		state = .main(.init())
	}

	func signInOffline (_ user: User, _ state: inout State) {
		guard state.isSplash else { return }
		state = .main(.init())
		analyticsService.log(.login(mode: .offline, username: user.username))
	}
}

private extension Root.Reducer {
	func logNetworkEvent (_ logRecord: LogRecord) {
		let logger = Logger(subsystem: "network", category: "network")

		let urlRequestFormatter = URLRequestFormatters.Default()
		let urlResponseFormatter = URLResponseFormatters.Default()

		if let urlRequest = logRecord.message.urlRequest {
			let string = urlRequestFormatter.convert(urlRequest)
			logger.info("\(logRecord.info.uppercased()) | \(string)")
		} else if case .response(let data, let response) = logRecord.message {
			logger.info("\(logRecord.info.uppercased()) | \(urlResponseFormatter.convert(response, body: data))")
		} else if case .error(let controllerError) = logRecord.message {
			logger.info("\(logRecord.info.uppercased()) | \(controllerError)")
		}
	}
}
