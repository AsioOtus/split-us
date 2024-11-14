import ComposableArchitecture
import Foundation
import Multitool

// MARK: - Feature
public enum AddRemoveContactButton { }

// MARK: - State
extension AddRemoveContactButton {
	@ObservableState
	public struct State: Equatable {
		let userId: UUID
		var isContact: Bool
		var request: Loadable<None> = .initial

		public init (userId: UUID, isContact: Bool) {
			self.userId = userId
			self.isContact = isContact
		}
	}
}

// MARK: - Action
extension AddRemoveContactButton {
	@CasePathable
	public enum Action {
		case onAddContactsButtonTap
		case onRemoveContactButtonTap

		case onContactAddingCompleted(Loadable<None>)
		case onContactRemovingCompleted(Loadable<None>)
	}
}
