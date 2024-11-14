import ComposableArchitecture
import DLModels
import Foundation
import Multitool
import ScreenAddContacts
import ScreenUserProfile

public enum ContactsList { }

extension ContactsList {
	@ObservableState
	public struct State: Equatable {
		var contacts: Loadable<[User.Compact]> = .initial
		var removeRequests: [Int] = []

		@Presents var addContact: AddContacts.State?
		@Presents var contactDetails: UserProfile.State?

		public init () { }
	}
}

extension ContactsList {
	@CasePathable
	public enum Action {
		case initialize
		case refresh

		case onContactsLoaded(Loadable<[User.Compact]>)

		case onContactTap(userId: UUID)
		case onAddContactScreenButtonTap

		case onRemoveContactButtonTap(userId: UUID)
		case onContactRemovingCompleted(userId: UUID)

		case addContact(PresentationAction<AddContacts.Action>)
		case contactDetails(PresentationAction<UserProfile.Action>)
	}
}
