import ComposableArchitecture
import ILComponents
import SwiftUI

extension UserSummaries {
	public struct Screen: View {
		let store: StoreOf<Reducer>
		
		public init (store: StoreOf<Reducer>) {
			self.store = store
		}
		
		public var body: some View {
			ForEach(store.summaries, id: \.self) { balance in
				UserSummaryView(userSummary: balance)
			}
		}
	}
}
