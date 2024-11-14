import ComponentsTCAUser
import ComposableArchitecture
import ILComponents
import ILModels
import ILModelsMappers
import ILUtilsTCA
import SwiftUI

extension UserProfile {
	public struct Screen: View {
		private let userScreenModelMapper = UserScreenModel.Mapper.default

		let store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			Form {
				ComposableLoadableView(store: store.scope(state: \.userDetails, action: \.self)) {
					StandardLoadingView()
				} loadingView: {
					StandardLoadingView()
				} successfulView: { store in
					userView(store)
				} failedView: { error in
					StandardErrorView(error: error)
				}
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

// MARK: - Subviews
private extension UserProfile.Screen {
	@ViewBuilder
	func userView (_ store: Store<UserProfile.State.UserDetails, UserProfile.Action>) -> some View {
		Section {
			UserDetailedView(user: userScreenModelMapper.map(store.user.user))
				.avatarSize(.large)
		}

		Section {
			AddRemoveContactButton.Screen(
				store: store.scope(state: \.addRemoveContactButton, action: \.addRemoveContactButton)
			)
			.frame(maxWidth: .infinity)
		}
	}
}
