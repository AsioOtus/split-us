import ComponentsTCAUser
import ComposableArchitecture
import ILComponents
import ILUtilsTCA
import SwiftUI

extension Summary {
	public struct Screen: View {
		let store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			List {
				ComposableLoadableView(
					store: store.scope(state: \.userSummaries, action: \.self),
					successfulView: successfulView
				)
			}
			.task {
				store.send(.initialize)
			}
			.refreshable {
				await store.send(.refresh).finish()
			}
			.toolbar {
				TitleSubtitleView(
					title: LocalizedStringKey(store.userGroup.name),
					subtitle: .summarySubtitle
				)
				.asToolbarItem(placement: .principal)
			}
		}
	}
}

private extension Summary.Screen {
	@ViewBuilder
	func successfulView (_ store: Store<Summary.State.UserSummaries, Summary.Action>) -> some View {
		if let currentUserSummary = store.currentUserSummary {
			Section {
				UserSummaryView(userSummary: currentUserSummary)
			}
		}

		Section {
			UserSummaries.Screen(store: store.scope(state: \.summaries, action: \.userSummaries))
		}
	}
}
