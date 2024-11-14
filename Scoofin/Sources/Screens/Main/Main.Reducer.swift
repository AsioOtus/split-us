import ComposableArchitecture
import DLModels
import ScreenContactList
import ScreenSettings
import ScreenUserGroupList

extension Main {
	@Reducer
	struct Reducer: ComposableArchitecture.Reducer {
		typealias State = Main.State
		typealias Action = Main.Action
		
		var body: some ReducerOf<Self> {
			Scope(state: \.userGroups, action: \.userGroups) {
				UserGroups.Reducer()
			}
			
			Scope(state: \.contactsList, action: \.contactsList) {
				ContactsList.Reducer()
			}
			
			Scope(state: \.settings, action: \.settings) {
				Settings.Reducer()
			}
		}
	}
}
