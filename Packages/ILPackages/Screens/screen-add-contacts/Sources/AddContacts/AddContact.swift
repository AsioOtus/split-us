import ComposableArchitecture
import DLModels
import Foundation
import ILComponents
import Multitool

public enum AddContacts { }

extension AddContacts {
	@ObservableState
	public struct State: Equatable {
		var username = ""

		var searchResult = Loadable<User.Contact?>.initial

		public init () { }
	}
}

extension AddContacts {
	@CasePathable
	public enum Action: BindableAction {
		case binding(BindingAction<State>)

		case initialize
		case finished

		case onSearchButtonTap
		case onCancelButtonTap

		case onSearchResultLoaded(Loadable<User.Contact?>)
	}
}
