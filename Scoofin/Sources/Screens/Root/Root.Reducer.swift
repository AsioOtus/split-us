import ComposableArchitecture
import Dependencies
import DLModels
import DLUtils
import NetworkUtil
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
		@Dependency(\.logoutEventChannel) var logoutEventChannel
		@Dependency(\.authorizationService) var authorizationService
		@Dependency(\.localAuthorizationService) var localAuthorizationService
		@Dependency(\.usersService) var usersService
		@Dependency(\.tokensValidationService) var tokensValidationService
		@Dependency(\.networkController) var networkController

		var body: some ReducerOf<Self> {
			Reduce { state, action in
				switch action {
				case .initialize:
					return initialize(&state)

				case .onUserLoaded(let user):
					onUserLoaded(user, &state)

				case .onLogout:
					return onLogout(&state)

				case .login(.onLoginRequestLoaded(.successful(let authCredentials))):
					onLogin(tokens: authCredentials.tokens, user: authCredentials.user, &state)

				case .login(.onRegistrationButtonTap):
					onRegistrationButtonTap(&state)

				case .registration(.onRegistrationLoaded(.success(let authCredentials))):
					onRegistration(tokens: authCredentials.tokens, user: authCredentials.user, &state)

				case .registration(.onLogInButtonTap):
					onLogInButtonTap(&state)

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
		.merge(
			subscribeLogout(),
			subscribeNetworkLogs(),
			loadUser(&state)
		)
	}

	func onUserLoaded (_ userResult: Loadable<User>, _ state: inout Root.Reducer.State) {
		switch userResult {
		case .initial:
			state = .splash

		case .processing:
			state = .splash

		case .successful(let user):
			state = .main(.init(currentUser: user))
			analyticsService.log(.login(mode: .silent, username: user.username))

		case .failed:
			localAuthorizationService.deleteTokenPair()
			state = .login(.init())
		}
	}

	func onLogout (_ state: inout Root.Reducer.State) -> Effect<Action> {
		defer {
			localAuthorizationService.deleteTokenPair()
			analyticsService.log(.logout(username: state.main?.currentUser.username))
			state = .login(.init())
		}

		guard let tokenPair = try? localAuthorizationService.savedTokenPair()
		else { return .none }

		return .run { _ in
			await authorizationService.deauthenticate(tokenPair: tokenPair)
		}
	}

	func onLogin (tokens: TokenPair, user: User, _ state: inout State) {
		signIn(tokens: tokens, user: user, &state)
	}

	func onRegistration (tokens: TokenPair, user: User, _ state: inout State) {
		signIn(tokens: tokens, user: user, &state)
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

		state = .splash

		return .run { send in
			let userResult = await Loadable.result { try await usersService.user() }
			await send(.onUserLoaded(userResult))
		}
	}

	func subscribeLogout () -> Effect<Action> {
		subscribe(to: logoutEventChannel) { _ in .onLogout }
	}

	func subscribeNetworkLogs () -> Effect<Action> {
		.run { _ in
			for await logRecord in networkController.logs {
				logNetworkEvent(logRecord)
			}
		}
	}

	func signIn (tokens: TokenPair, user: User, _ state: inout State) {
		do {
			try localAuthorizationService.saveTokenPair(tokens)
			state = .main(.init(currentUser: user))
		} catch {
			
		}
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
