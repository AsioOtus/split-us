import Dependencies

public struct EmailValidationService {
	public struct Mismatch: OptionSet {
		public static let empty = Self(rawValue: 1 << 0)
		public static let invalid = Self(rawValue: 1 << 1)
		
		public var rawValue: Int
		
		public init (rawValue: Int) {
			self.rawValue = rawValue
		}
	}
	
	// swiftlint:disable comma
	private let regex = #/^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$/#
	// swiftlint:enable comma
	
	public func validate (_ email: String) -> Mismatch {
		guard !email.isEmpty else { return .empty }
		guard (try? regex.wholeMatch(in: email)) != nil else { return .invalid }
		return []
	}
}

public struct EmailValidationServiceDependencyKey: DependencyKey {
	public static var liveValue: EmailValidationService {
		EmailValidationService()
	}
}

public extension DependencyValues {
	var emailValidationService: EmailValidationService {
		get { self[EmailValidationServiceDependencyKey.self] }
		set { self[EmailValidationServiceDependencyKey.self] = newValue }
	}
}
