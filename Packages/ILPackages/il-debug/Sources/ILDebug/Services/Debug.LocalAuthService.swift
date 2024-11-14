import DLServices
import DLModels

extension Debug {
	public final class InMemoryLocalAuthService: PLocalAuthorizationService {
		static let `default` = InMemoryLocalAuthService(tokenPair: nil)

		public var tokenPair: TokenPair?

		private init (tokenPair: TokenPair? = nil) {
			self.tokenPair = tokenPair
		}

		public func savedTokenPair () throws -> TokenPair {
			guard let tokenPair else { throw Debug.Error() }
			return tokenPair
		}

		public func saveTokenPair (_ tokenPair: TokenPair) throws {
			self.tokenPair = tokenPair
		}

		public func deleteTokenPair () {
			self.tokenPair = nil
		}
	}
}
