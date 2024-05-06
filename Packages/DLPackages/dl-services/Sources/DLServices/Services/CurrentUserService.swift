import Dependencies
import Foundation
import DLModels

public protocol PCurrentUserService {
	func get () -> User?
	func set (user: User)
}

public class CurrentUserService: PCurrentUserService {
	private var user: User?
	
	public func get () -> User? {
		user
	}
	
	public func set (user: User) {
		self.user = user
	}
}

extension CurrentUserService: DependencyKey {
	public static var liveValue: PCurrentUserService {
		CurrentUserService()
	}
}

public extension DependencyValues {
	var currentUserService: PCurrentUserService {
		get { self[CurrentUserService.self] }
		set { self[CurrentUserService.self] = newValue }
	}
}
