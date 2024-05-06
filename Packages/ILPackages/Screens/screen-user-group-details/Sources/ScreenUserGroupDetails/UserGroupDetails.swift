import ComposableArchitecture
import DLServices
import Foundation
import ScreenSummary
import ScreenTransferList
import ScreenUserGroupInfo
import DLModels
import DLUtils

public enum UserGroupDetails { }

extension UserGroupDetails {
	@ObservableState
	public struct State: Equatable, Identifiable {
		let currentUser: User
		let userGroup: UserGroup

		var transferList: TransferList.State

		@Presents var summary: Summary.State?
		@Presents var userGroupInfo: UserGroupInfo.State?

		public var id: UUID { userGroup.id }

		public init (userGroup: UserGroup, currentUser: User) {
			self.currentUser = currentUser
			self.userGroup = userGroup
			self.transferList = .init(userGroup: userGroup)
		}
	}
}

extension UserGroupDetails {
	@CasePathable
	public enum Action {
		case onTitleTap
		case onSummaryButtonTap
		case onInfoButtonTap

		case transferList(TransferList.Action)

		case summary(PresentationAction<Summary.Action>)
		case userGroupInfo(PresentationAction<UserGroupInfo.Action>)
	}
}
