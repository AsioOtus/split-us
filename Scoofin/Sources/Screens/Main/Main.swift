import ComposableArchitecture
import DLModels
import ScreenContactList
import ScreenSettings
import ScreenUserGroupList

enum Main { }

extension Main {
	@ObservableState
	struct State: Equatable {
		var userGroups: UserGroups.State
		var contactsList: ContactsList.State
		var settings: Settings.State

		init () {
			self.userGroups = .init()
			self.contactsList = .init()
			self.settings = .init()
		}
	}
}

extension Main {
	@CasePathable
	enum Action {
		case userGroups(UserGroups.Reducer.Action)
		case contactsList(ContactsList.Action)
		case settings(Settings.Action)
	}
}
