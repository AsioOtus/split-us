import ComposableArchitecture
import Foundation
import ScreenAddContacts
import ScreenUserDetails
import DLModels
import DLUtils

public enum ContactsList { }

extension ContactsList {
	@ObservableState
	public struct State: Equatable {
		var contacts: Loadable<[User.Compact]> = .initial()
		var removeRequests: [Int] = []

		@Presents var addContact: AddContacts.State?
		@Presents var contactDetails: UserDetails.State?

		public init () { }
	}
}

extension ContactsList {
	@CasePathable
	public enum Action {
		case initialize
		case refresh

		case onAddContactScreenButtonTap

		case onContactsLoaded(Loadable<[User.Compact]>)

		case onRemoveContactButtonTap(userId: UUID)
		case onContactRemovingCompleted(userId: UUID)

		case addContact(PresentationAction<AddContacts.Action>)
		case contactDetails(PresentationAction<UserDetails.Action>)
	}
}
