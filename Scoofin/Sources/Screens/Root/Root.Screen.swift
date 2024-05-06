import ComposableArchitecture
import ScreenLogin
import ScreenRegistration
import SwiftUI
import UnavailablePlaceholderComponents
import DLUtils

extension Root {
	struct Screen: View {
		let store: StoreOf<Root.Reducer>

		var body: some View {
			Group {
				switch store.state {
				case .splash:
					if store.scope(state: \.splash, action: \.splash) != nil {
						StandardLoadingView()
					}

				case .main:
					if let store = store.scope(state: \.main, action: \.main) {
						Main.Screen(store: store)
					}

				case .login:
					if let store = store.scope(state: \.login, action: \.login) {
						Login.Screen(store: store)
					}

				case .registration:
					if let store = store.scope(state: \.registration, action: \.registration) {
						Registration.Screen(store: store)
					}
				}
			}
			.tint(.red)
			.task {
				store.send(.initialize)
			}
		}
	}
}
