import ComponentsTCAGeneral
import ComposableArchitecture
import DLModels
import DLServices
import Foundation

public enum UserSingleSelector {
	@Reducer
	public struct Reducer {
		public typealias State = SingleSelector<User.Compact>.Reducer.State
		public typealias Action = SingleSelector<User.Compact>.Reducer.Action

		@Dependency(\.usersService) var usersService
		@Dependency(\.userLocalService) var userLocalService

		public init () { }

		public var body: some ReducerOf<Self> {
			SingleSelector<User.Compact>.Reducer(
				loadPage: { id, page in
					try await usersService.userGroupMembers(userGroupId: id, page: page).map(\.user)
				},
				loadPageLocal: { id, page in
					try userLocalService.userGroupMembers(userGroupId: id, page: page).map(\.user)
				}
			)
		}
	}
}
