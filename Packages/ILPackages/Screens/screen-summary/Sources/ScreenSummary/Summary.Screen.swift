import AmountComponents
import ComposableArchitecture
import DLUtils
import ILUtils
import SwiftUI
import UserComponents

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
				titleToolbarItem()
			}
		}
	}
}

private extension Summary.Screen {
	@ViewBuilder
	func successfulView (_ store: Store<Summary.State.UserSummaries, Summary.Action>) -> some View {
		Section {
			UserSummaryView(userSummary: store.currentUserSummary)
		}

		Section {
			UserSummaries.Screen(store: store.scope(state: \.summaries, action: \.userSummaries))
		}
	}
}

// MARK: - Subviews
private extension Summary.Screen {
	func titleToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .principal) {
			VStack {
				Text(store.userGroup.name)
				Text(.summarySubtitle)
					.foregroundStyle(.secondary)
			}
		}
	}
}
