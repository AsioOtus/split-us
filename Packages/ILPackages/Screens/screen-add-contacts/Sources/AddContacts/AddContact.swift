import ComposableArchitecture
import Multitool
import Foundation
import DLModels
import DLUtils

public enum AddContacts { }

extension AddContacts {
	@ObservableState
	public struct State: Equatable {
		var username = ""

		var searchResult = Loadable<User.ContactSearch?>.initial()
		var addRemoveRequest = Loadable<None>.initial()

		public init () { }
	}
}

extension AddContacts {
	public enum Action: BindableAction {
		case binding(BindingAction<State>)

		case initialize
		case finished

		case onSearchButtonTap
		case onCancelButtonTap
		case onAddContactsButtonTap(userId: UUID)
		case onRemoveContactButtonTap(userId: UUID)

		case onSearchResultLoaded(Loadable<User.ContactSearch?>)
		case onContactAddingCompleted(Loadable<None>)
		case onContactRemovingCompleted(Loadable<None>)
	}
}
