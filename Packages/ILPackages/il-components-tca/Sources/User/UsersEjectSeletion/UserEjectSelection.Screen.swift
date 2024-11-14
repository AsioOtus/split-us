import ComposableArchitecture
import ILComponents
import ILModels
import ILModelsMappers
import SwiftUI

extension UserEjectSelection {
	public struct Screen: View {
		let store: StoreOf<Reducer>

		let userScreenModelMapper = UserScreenModel.Mapper.default

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			Section {
				ForEach(store.selectedUsers, id: \.id) { user in
					UserDetailedView(user: userScreenModelMapper.map(user))
						.onTapGesture {
							store.send(.onUserDeselected(user), animation: .default)
						}
				}
			} header: {
				Text(.userEjectSelectionSelectedSectionHeader)
			}

			Section {
				ForEach(store.unselectedUsers, id: \.id) { user in
					UserDetailedView(user: userScreenModelMapper.map(user))
						.onTapGesture {
							store.send(.onUserSelected(user), animation: .default)
						}
				}
			} header: {
				Text(.userEjectSelectionAllSectionHeader)
			}
		}
	}
}
