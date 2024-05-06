import ComposableArchitecture
import ScreenSummary
import ScreenTransferList
import ScreenUserGroupInfo

extension UserGroupDetails {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = UserGroupDetails.State
		public typealias Action = UserGroupDetails.Action

		public init () { }

		public var body: some ReducerOf<Self> {
			Reduce { state, action in
				switch action {
				case .onTitleTap: onSummaryButtonTap(&state)
				case .onSummaryButtonTap: onSummaryButtonTap(&state)
				case .onInfoButtonTap: onInfoButtonTap(&state)

				case .transferList: break
				case .summary: break
				case .userGroupInfo: break
				}

				return .none
			}
			.ifLet(\.$summary, action: \.summary) {
				Summary.Reducer()
			}
			.ifLet(\.$userGroupInfo, action: \.userGroupInfo) {
				UserGroupInfo.Reducer()
			}

			Scope(state: \.transferList, action: \.transferList) {
				TransferList.Reducer()
			}
		}
	}
}

private extension UserGroupDetails.Reducer {
	func onInfoButtonTap (_ state: inout State) {
		state.userGroupInfo = .init(userGroup: state.userGroup)
	}

	func onSummaryButtonTap (_ state: inout State) {
		state.summary = .init(currentUser: state.currentUser, userGroup: state.userGroup)
	}
}
