import Dependencies
import SimpleKeychain
import DLModels

public protocol PLocalAuthorizationService {
	func savedTokenPair () throws -> TokenPair
	func saveTokenPair (_ tokenPair: TokenPair) throws
	func deleteTokenPair ()
}

extension LocalAuthorizationService {
	public enum Keychain {
		static let serviceName = "scoofin-standard"

		public enum Keys {
			public enum Auth: String {
				case accessToken
				case refreshToken
			}
		}
	}
}

public struct LocalAuthorizationService: PLocalAuthorizationService {
	let keychain = SimpleKeychain(
		service: Keychain.serviceName
	)

	public func savedTokenPair () throws -> TokenPair {
		let accessToken = try keychain.string(forKey: Keychain.Keys.Auth.accessToken.rawValue)
		let refreshToken = try keychain.string(forKey: Keychain.Keys.Auth.refreshToken.rawValue)

		let tokenPair = TokenPair(
			access: accessToken,
			refresh: refreshToken
		)

		return tokenPair
	}

	public func saveTokenPair (_ tokenPair: TokenPair) throws {
		try keychain.set(tokenPair.access, forKey: Keychain.Keys.Auth.accessToken.rawValue)
		try keychain.set(tokenPair.refresh, forKey: Keychain.Keys.Auth.refreshToken.rawValue)
	}

	public func deleteTokenPair () {
		try? keychain.deleteItem(forKey: Keychain.Keys.Auth.accessToken.rawValue)
		try? keychain.deleteItem(forKey: Keychain.Keys.Auth.refreshToken.rawValue)
	}
}

extension LocalAuthorizationService: DependencyKey {
	public static var liveValue: PLocalAuthorizationService {
		LocalAuthorizationService()
	}
}

public extension DependencyValues {
	var localAuthorizationService: PLocalAuthorizationService {
		get { self[LocalAuthorizationService.self] }
		set { self[LocalAuthorizationService.self] = newValue }
	}
}
