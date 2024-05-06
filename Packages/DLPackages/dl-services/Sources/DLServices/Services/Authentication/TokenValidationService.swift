import Dependencies
import Foundation
import JWTDecode
import DLModels

public protocol PTokensValidationService {
	func isExpired (tokenPair: TokenPair) -> Bool
	func isAccessTokenNearlyExpired (tokenPair: TokenPair) -> Bool
	func userId (from tokenPair: TokenPair) -> UUID?
}

public struct TokensValidationService: PTokensValidationService {
	public func isExpired (tokenPair: TokenPair) -> Bool {
		let jwt = try? decode(jwt: tokenPair.access)
		return jwt?.expired == false
	}
	
	public func isAccessTokenNearlyExpired (tokenPair: TokenPair) -> Bool {
		guard
			let jwt = try? decode(jwt: tokenPair.access),
			let tokenCreationDate = jwt.issuedAt,
			let tokenExpirationDate = jwt.expiresAt
		else { return false }
		
		let tokenLifetime = tokenExpirationDate.timeIntervalSince(tokenCreationDate)
		let tokenAge = Date().timeIntervalSince(tokenCreationDate)
		
		let pastLifePercent = tokenAge / tokenLifetime
		let isNearlyExpired = pastLifePercent > 0.75
		
		return isNearlyExpired
	}
	
	public func userId (from tokenPair: TokenPair) -> UUID? {
		let jwt = try? decode(jwt: tokenPair.access)
		let userIdClaimValue = jwt?.claim(name: "userId").string
		let userId = userIdClaimValue.flatMap { UUID(uuidString: $0) }
		return userId
	}
}

extension TokensValidationService: DependencyKey {
	public static var liveValue: PTokensValidationService {
		TokensValidationService()
	}
}

public extension DependencyValues {
	var tokensValidationService: PTokensValidationService {
		get { self[TokensValidationService.self] }
		set { self[TokensValidationService.self] = newValue }
	}
}
