import ComposableArchitecture
import DLServices
import DLUtils
import ILModels
import ILModelsMappers
import ILUtils
import DLModels
import SwiftUI
import UnavailablePlaceholderComponents
import UserComponents

extension UserDetails {
	public struct Screen: View {
		let userInfoModelMapper = UserInfoModel.Mapper.default

		let store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			Form {
				contentView()
			}
			.task {
				store.send(.initialize)
			}
			.refreshable {
				await store.send(.refresh).finish()
			}
		}
	}
}

private extension UserDetails.Screen {
	func contentView () -> some View {
		LoadableView(
			value: store.user,
			loadingView: loadingView,
			successfulView: successfulView
		)
	}

	func loadingView () -> some View {
		StandardLoadingView()
	}

	@ViewBuilder
	func successfulView (_ user: User.Compact) -> some View {
		let userInfo = userInfoModelMapper.map(user)

		UserMinimalView(initials: userInfo.initials, avatar: userInfo.image)
			.controlSize(.extraLarge)
			.horizontallyCentered()

		UserNameSurnameView(name: userInfo.name, surname: userInfo.surname)
		UserUsernameView(username: userInfo.username)
	}
}
