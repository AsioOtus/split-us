import ComposableArchitecture
import ILFormatters
import ILModels
import SwiftUI
import UserComponents

extension Profile {
	public struct Screen: View {
		let store: StoreOf<Profile.Reducer>

		public init (store: StoreOf<Profile.Reducer>) {
			self.store = store
		}

		public var body: some View {
			NavigationStack {
				Form {
					Section {
						UserProfileView(
							user: .init(
								name: store.user.name,
								surname: store.user.surname,
								username: store.user.username,
								email: store.user.email,
								image: nil,
								initials: InitialsFormatter.default.format(
									name: store.user.name,
									surname: store.user.surname,
									username: store.user.username
								)
							)
						)
						.controlSize(.extraLarge)
					}

					Section {
						Button(.generalActionSignOut, role: .destructive) {
							store.send(.logout)
						}
					}
				}
				.navigationTitle(.profileTitle)
			}
		}
	}
}
