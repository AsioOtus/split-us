import ComponentsTCAGeneral
import ComposableArchitecture
import DLModels
import ILComponents
import ILModels
import ILModelsMappers
import SwiftUI

extension UserSingleSelector {
	public struct Screen: View {
		let userScreenModelMapper = UserScreenModel.Mapper.default
		let store: StoreOf<SingleSelector<User.Compact>.Reducer>

		public init (store: StoreOf<SingleSelector<User.Compact>.Reducer>) {
			self.store = store
		}

		public var body: some View {
			SingleSelector.ButtonView(
				store: store
			) { user in
				UserShortView(user: userScreenModelMapper.map(user))
			} listItemView: { user in
				UserDetailedView(user: userScreenModelMapper.map(user))
			} pickerItemView: { user in
				Button { } label: {
					UserNameSurnameText(name: user.name, surname: user.surname)
					UserUsernameText(username: user.username)
					UserImage(userInfo: userScreenModelMapper.map(user))
				}
			}
		}
	}
}
