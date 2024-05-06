import Foundation
import ComposableArchitecture
import DLServices
import DLModels
import DLUtils

// MARK: - Feature
public enum UserDetails { }

// MARK: - State
extension UserDetails {
	@ObservableState
	public struct State: Equatable {
		public let userId: UUID
		public var user: Loadable<User.Compact> = .initial()

		public init (userId: UUID) {
			self.userId = userId
		}
	}
}

// MARK: - Action
extension UserDetails {
	public enum Action {
		case initialize
		case refresh

		case onUserLoadingCompleted(Loadable<User.Compact>)
	}
}
