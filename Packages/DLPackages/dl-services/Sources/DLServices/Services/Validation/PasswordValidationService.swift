import Dependencies

/// Password validation
/// Must contains:
/// At lease 8 characters
/// At least 1 digit
/// At least 1 non lower cased character
public struct PasswordValidationService {
	public struct Mismatch: OptionSet {
		public static let empty = Self(rawValue: 1 << 0)
		public static let tooShort = Self(rawValue: 1 << 1)
		public static let withoutDigits = Self(rawValue: 1 << 2)
		public static let withoutNonLowerCased = Self(rawValue: 1 << 3)
		
		public var rawValue: Int
		
		public init (rawValue: Int) {
			self.rawValue = rawValue
		}
	}
	
	public func validate (_ password: String) -> Mismatch {
		guard !password.isEmpty else { return .empty }
		
		var mismatch: Mismatch = []
		
		if password.count < 8 {
			mismatch.insert(.tooShort)
		}
		
		if !password.contains(#/\d/#) {
			mismatch.insert(.withoutDigits)
		}
		
		if !password.contains(#/[^a-z0-9]+/#) {
			mismatch.insert(.withoutNonLowerCased)
		}
		
		return mismatch
	}
}

public struct PasswordValidationServiceDependencyKey: DependencyKey {
	public static var liveValue: PasswordValidationService {
		PasswordValidationService()
	}
}

public extension DependencyValues {
	var passwordValidationService: PasswordValidationService {
		get { self[PasswordValidationServiceDependencyKey.self] }
		set { self[PasswordValidationServiceDependencyKey.self] = newValue }
	}
}
