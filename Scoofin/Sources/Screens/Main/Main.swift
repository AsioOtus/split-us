import ComposableArchitecture
import DLModels
import DLUtils
import ScreenContactList
import ScreenProfile
import ScreenUserGroupList

enum Main { }

extension Main {
	@ObservableState
	struct State: Equatable {
		let currentUser: User

		var userGroups: UserGroups.State
		var contactsList: ContactsList.State
		var profile: Profile.State

		init (currentUser: User) {
			self.currentUser = currentUser

			self.userGroups = .init(currentUser: currentUser)
			self.contactsList = .init()
			self.profile = .init(user: currentUser)
		}
	}
}

extension Main {
	@CasePathable
	enum Action {
		case userGroups(UserGroups.Reducer.Action)
		case contactsList(ContactsList.Action)
		case profile(Profile.Action)
	}
}
