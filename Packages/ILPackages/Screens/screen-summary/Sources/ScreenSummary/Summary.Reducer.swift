import ComposableArchitecture
import DLModels
import DLServices
import Foundation
import struct IdentifiedCollections.Identified
import Multitool

extension Summary {
	public struct Reducer {
		@Dependency(\.currentUserService) var currentUserService
		@Dependency(\.userGroupsService) var userGroupsService
		
		public init () { }
	}
}

extension Summary.Reducer: ComposableArchitecture.Reducer {
	public var body: some ComposableArchitecture.Reducer<Summary.State, Summary.Action> {
		Reduce { state, action in
			switch action {
			case .initialize:
				return refresh(state.userGroup.id)
				
			case .refresh:
				return refresh(state.userGroup.id)
				
			case .onSummaryLoaded(let userSummariesResult):
				state.userSummaries = userSummariesResult.catchingMapValue { try map($0, state) }

			case .userSummaries:
				break
			}
			
			return .none
		}
	}
}

private extension Summary.Reducer {
	func refresh (_ userGroupId: UUID) -> Effect<Action> {
		.run { send in
			let summaryResult = await Loadable { try await userGroupsService.summary(userGroupId: userGroupId) }
			await send(.onSummaryLoaded(summaryResult))
		}
	}
	
	func map (_ userSummaries: [UserSummary], _ state: State) throws -> State.UserSummaries {
		let currentUserSummary = userSummaries.first(where: { $0.user.id == currentUserService.user.value?.id })

		let otherUsersSummaries = if let currentUserSummary {
			userSummaries.filter { $0.user.id != currentUserSummary.user.id }
		} else {
			userSummaries
		}
		
		return .init(
			currentUserSummary: currentUserSummary,
			otherUsersSummaries: otherUsersSummaries
		)
	}
}
