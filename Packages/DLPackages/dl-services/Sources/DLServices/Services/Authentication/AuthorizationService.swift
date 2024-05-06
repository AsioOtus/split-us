import Dependencies
import Foundation
import DLNetwork
import DLModels

public protocol PAuthorizationService {
	func register (user: User.New) async throws -> (tokens: TokenPair, user: User)
	func authenticate (username: String, password: String) async throws -> (tokens: TokenPair, user: User)
	func reauthenticate (refreshToken: String, userId: UUID) async throws -> TokenPair
	func deauthenticate (tokenPair: TokenPair) async
}

public struct AuthorizationService: PAuthorizationService {
	@Dependency(\.networkController) var networkController

	public func register (user: User.New) async throws -> (tokens: TokenPair, user: User) {
		let responseModel = try await networkController
			.send(Requests.Register(user: user))
			.unfold()

		let (tokens, user) = (responseModel.tokenPair, responseModel.user)
		return (tokens, user)
	}

	public func authenticate (username: String, password: String) async throws -> (tokens: TokenPair, user: User) {
		let responseModel = try await networkController
			.send(Requests.Authenticate(username: username, password: password))
			.unfold()

		let (tokens, user) = (responseModel.tokenPair, responseModel.user)
		return (tokens, user)
	}

	public func reauthenticate (refreshToken: String, userId: UUID) async throws -> TokenPair {
		let newTokenPair = try await networkController
			.send(Requests.Reauthenticate(userId: userId, refreshToken: refreshToken))
			.unfold()
			.tokenPair

		return newTokenPair
	}

	public func deauthenticate (tokenPair: TokenPair) async {
		_ = try? await networkController
			.send(
				Requests.Deauthenticate(refreshToken: tokenPair.refresh),
				responseModel: Never.self,
				configurationUpdate: {
					$0.addHeader(key: "Authorization", value: "Bearer \(tokenPair.access)")
				}
			)
	}
}

extension AuthorizationService: DependencyKey {
	public static var liveValue: PAuthorizationService {
		AuthorizationService()
	}
}

public extension DependencyValues {
	var authorizationService: PAuthorizationService {
		get { self[AuthorizationService.self] }
		set { self[AuthorizationService.self] = newValue }
	}
}
