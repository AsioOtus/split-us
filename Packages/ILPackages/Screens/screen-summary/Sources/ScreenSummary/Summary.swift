import AmountComponents
import ComposableArchitecture
import Foundation
import DLModels
import UserComponents
import DLUtils

public enum Summary { }

extension Summary {
	@ObservableState
	public struct State: Equatable {
		public let currentUser: User
		public let userGroup: UserGroup
		
		public var userSummaries: Loadable<UserSummaries> = .initial()
		
		public init (
			currentUser: User,
			userGroup: UserGroup
		) {
			self.currentUser = currentUser
			self.userGroup = userGroup
		}
	}
}

extension Summary.State {
	@ObservableState
	public struct UserSummaries: Equatable {
		public let currentUserSummary: UserSummary
		public let otherUsersSummaries: [UserSummary]

		public var summaries: AmountComponents.UserSummaries.Reducer.State {
			.init(summaries: otherUsersSummaries)
		}
	}
}

extension Summary {
	@CasePathable
	public enum Action {
		case initialize
		case refresh
		
		case onSummaryLoaded(Loadable<[UserSummary]>)
		
		case userSummaries(UserSummaries.Reducer.Action)
	}
}
