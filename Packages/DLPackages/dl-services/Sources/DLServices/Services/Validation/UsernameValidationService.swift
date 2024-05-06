import Dependencies

public struct UsernameValidationService {
	public struct Mismatch: OptionSet {
		public static let empty = Self(rawValue: 1 << 0)
		public static let tooShort = Self(rawValue: 1 << 1)
		public static let tooLong = Self(rawValue: 1 << 2)
		public static let containsProhibitedSymbols = Self(rawValue: 1 << 3)
		
		public var rawValue: Int
		
		public init (rawValue: Int) {
			self.rawValue = rawValue
		}
	}
	
	private let allowedSymbols = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
	private let minLength = 4
	private let maxLength = 40
	
	public func validate (_ username: String) -> Mismatch {
		guard !username.isEmpty else { return .empty }
		
		var mismatch: Mismatch = []
		
		if username.count < minLength {
			mismatch.insert(.tooShort)
		}
		
		if username.count > maxLength {
			mismatch.insert(.tooLong)
		}
		
		if !username.allSatisfy(allowedSymbols.contains) {
			mismatch.insert(.containsProhibitedSymbols)
		}
		
		return mismatch
	}
}

public struct UsernameValidationServiceDependencyKey: DependencyKey {
	public static var liveValue: UsernameValidationService {
		UsernameValidationService()
	}
}

public extension DependencyValues {
	var usernameValidationService: UsernameValidationService {
		get { self[UsernameValidationServiceDependencyKey.self] }
		set { self[UsernameValidationServiceDependencyKey.self] = newValue }
	}
}
