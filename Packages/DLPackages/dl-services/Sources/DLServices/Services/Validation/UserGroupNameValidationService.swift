import Dependencies

/// Password validation
/// Must contains:
/// At lease 8 characters
/// At least 1 digit
/// At least 1 non lower cased character
public struct UserGroupNameValidationService {
	public struct Mismatch: OptionSet {
		public static let empty = Self(rawValue: 1 << 0)
		
		public var rawValue: Int
		
		public init (rawValue: Int) {
			self.rawValue = rawValue
		}
	}
	
	public func validate (_ name: String) -> Mismatch {
		guard !name.isEmpty else { return .empty }
		return []
	}
}

public struct UserGroupNameValidationServiceDependencyKey: DependencyKey {
	public static var liveValue: UserGroupNameValidationService {
		UserGroupNameValidationService()
	}
}

public extension DependencyValues {
	var userGroupNameValidationService: UserGroupNameValidationService {
		get { self[UserGroupNameValidationServiceDependencyKey.self] }
		set { self[UserGroupNameValidationServiceDependencyKey.self] = newValue }
	}
}
