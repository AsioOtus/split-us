import ComposableArchitecture
import ILDebug
import ILDesignResources
import SwiftUI

// MARK: - Screen
extension Debug.Configuration {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}
		
		public var body: some View {
			Group {
				HStack {
					Text("Version")
					
					Spacer()
					
					Text(store.appVersion)
						.foregroundStyle(.gray)
				}
				
				HStack {
					Text("Server")
					
					Spacer()
					
					Picker("", selection: $store.selectedConfiguration) {
						ForEach(store.configurations, id: \.self) { configuration in
							Text(configuration.url.host ?? "")
						}
					}
					.foregroundStyle(.gray)
				}
				
				HStack {
					Text("Subpath")
					Spacer()
					TextField("", text: $store.subpath)
						.multilineTextAlignment(.trailing)
				}

				Toggle("Offline mode", isOn: $store.isOfflineMode)
			}
			.task {
				store.send(.initialize)
			}
		}
	}
}
