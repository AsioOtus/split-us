import ComposableArchitecture
import ILComponents
import ILDebug
import ILDebugTCA
import ILFormatters
import ILModels
import ILUtils
import SwiftUI

extension Settings {
	public struct Screen: View {
		@Bindable var store: StoreOf<Settings.Reducer>

		public init (store: StoreOf<Settings.Reducer>) {
			self.store = store
		}

		public var body: some View {
			NavigationStack {
				Form {
					Section {
						userView()
					}

					Section {
						Button(.settingsClearSavedData, role: .destructive) {
							store.send(.onClearPersistentDataButtonTap)
						}
					}

					Section {
						Button(.generalActionSignOut, role: .destructive) {
							store.send(.logout)
						}
					}

					Section {
						Debug.Configuration.Screen(
							store: store.scope(
								state: \.debugConfiguration,
								action: \.debugConfiguration
							)
						)
					} header: {
						Text("Debug")
					}
				}
				.confirmationDialog($store.scope(state: \.clearPersistentDataDialog, action: \.clearPersistentDataDialog))
				.navigationTitle(.settingsTitle)
				.task {
					store.send(.initialize)
				}
			}
		}
	}
}

// MARK: - Subviews
private extension Settings.Screen {
	func userView () -> some View {
		LoadableView(
			value: store.user
		) {
			EmptyView()
		} loadingView: {
			StandardLoadingView()
		} successfulView: { user in
			UserProfileView(
				user: .init(
					name: user.name,
					surname: user.surname,
					username: user.username,
					email: user.email,
					image: nil,
					initials: InitialsFormatter.default.format(
						name: user.name,
						surname: user.surname,
						username: user.username
					),
					color: UUIDHSVAConverter.default.convert(user.id).color
				)
			)
			.avatarSize(.extraLarge)
		} failedView: { error in
			StandardErrorView(error: error)
		}
	}
}
