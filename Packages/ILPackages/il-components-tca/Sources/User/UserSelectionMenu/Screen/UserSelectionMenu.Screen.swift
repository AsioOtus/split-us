import SwiftUI
import ComposableArchitecture

extension UserSelectionMenu {
	public struct Screen: View {
		let store: StoreOf<Reducer>
		
		public init (store: StoreOf<Reducer>) {
			self.store = store
		}
		
		public var body: some View {
			Menu {
				ForEach(store.users, id: \.self) { user in
					Button {
						store.send(.selectUser(userId: user.id))
					} label: {
						Text(user.value)
					}
				}
			} label: {
				if let userName = store.selectedUser?.value {
					Text(userName)
				} else {
					Text("Select user")
				}
			}
		}
	}
}
