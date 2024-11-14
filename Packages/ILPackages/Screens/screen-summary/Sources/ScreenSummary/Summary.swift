import ComponentsTCAUser
import ComposableArchitecture
import DLModels
import Foundation
import ILComponents
import Multitool

public enum Summary { }

extension Summary {
	@ObservableState
	public struct State: Equatable {
		public let userGroup: UserGroup
		
		public var userSummaries: Loadable<UserSummaries> = .initial
		
		public init (
			userGroup: UserGroup
		) {
			self.userGroup = userGroup
		}
	}
}

extension Summary.State {
	@ObservableState
	public struct UserSummaries: Equatable {
		public let currentUserSummary: UserSummary?
		public let otherUsersSummaries: [UserSummary]

		public var summaries: ComponentsTCAUser.UserSummaries.Reducer.State {
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
