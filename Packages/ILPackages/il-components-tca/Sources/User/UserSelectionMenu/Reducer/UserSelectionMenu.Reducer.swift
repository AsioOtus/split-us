import Foundation
import ComposableArchitecture
import struct IdentifiedCollections.Identified

extension UserSelectionMenu {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public var body: some ReducerOf<Self> {
			Reduce { state, action in
				switch action {
				case .selectUser(userId: let userId):
					state.selectedUser = state.users.first { $0.id == userId }
					
				case .unselectUser: break
				}
				
				return .none
			}
		}
	}
}

extension UserSelectionMenu.Reducer {
	@ObservableState
	public struct State: Equatable {
		public typealias User = Identified<UUID, String>
		
		let users: [User]
		var selectedUser: User?
		
		public init (
			users: [User],
			selectedUser: User? = nil
		) {
			self.users = users
			self.selectedUser = selectedUser
		}
	}
}

extension UserSelectionMenu.Reducer {
	public enum Action: Equatable {
		case selectUser(userId: UUID)
		case unselectUser
	}
}
