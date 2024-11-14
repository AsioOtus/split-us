import DLServices
import Foundation
import JWTDecode
import DLModels

extension Debug {
	public struct TokensValidationService: PTokensValidationService {
		public static let alwaysValid = Self(isAlwaysValid: true)

		public let isAlwaysValid: Bool

		public func isExpired (tokenPair: TokenPair) -> Bool {
			isAlwaysValid
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
}
