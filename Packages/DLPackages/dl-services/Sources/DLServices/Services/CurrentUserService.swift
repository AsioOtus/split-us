import Combine
import Dependencies
import Foundation
import DLModels

public protocol PCurrentUserService {
	var user: CurrentValueSubject<User?, Never> { get }

	func set (user: User)
	func delete ()
}

public class CurrentUserService: PCurrentUserService {
	public private(set) var user: CurrentValueSubject<User?, Never> = .init(nil)

	public func set (user: User) {
		self.user.send(user)
	}

	public func delete () {
		self.user.send(nil)
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
