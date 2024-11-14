import Foundation
import ComponentsTCAUser
import ComposableArchitecture
import DLServices
import DLModels
import Multitool

// MARK: - Feature
public enum UserProfile { }

// MARK: - State
extension UserProfile {
	@ObservableState
	public struct State: Equatable {
		let userId: UUID
		var userDetails: Loadable<UserDetails> = .initial

		public init (userId: UUID) {
			self.userId = userId
		}
	}
}

extension UserProfile.State {
	@ObservableState
	struct UserDetails: Equatable {
		var user: User.Contact
		var addRemoveContactButton: AddRemoveContactButton.State

		init (user: User.Contact, addRemoveContactButton: AddRemoveContactButton.State) {
			self.user = user
			self.addRemoveContactButton = addRemoveContactButton
		}
	}
}

// MARK: - Action
extension UserProfile {
	@CasePathable
	public enum Action {
		case initialize
		case refresh

		case onUserLoadingCompleted(Loadable<User.Contact>)

		case addRemoveContactButton(AddRemoveContactButton.Action)
	}
}
