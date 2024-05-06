import ComposableArchitecture
import DLModels
import DLUtils
import ScreenContactList
import ScreenProfile
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
			
			Scope(state: \.profile, action: \.profile) {
				Profile.Reducer()
			}
		}
	}
}
