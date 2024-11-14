import ComposableArchitecture
import DLModels
import Foundation

public enum SingleSelector <Item: Hashable> {
	@ObservableState
	public struct State {
		public var pageLoading: PageLoading<Item>.State
		public var selectedPageItem: PageItem<Item>?

		var isListPresented = false
		
		var mode: Mode {
			.picker
		}

		public var selectedItem: Item? {
			selectedPageItem?.item
		}

		public init (sourceLoadingId: UUID) {
			let loadingId = sourceLoadingId
			self.pageLoading = .init(
				loadingId: loadingId,
				pageSize: 100,
				remainingBeforeLoadingThreshold: 20
			)
		}

		public enum Mode {
			case list
			case picker
		}
	}

	@CasePathable
	public enum Action: BindableAction {
		case binding(BindingAction<State>)

		case onListButtonTap
		case itemSelected(PageItem<Item>?)

		case pageLoading(PageLoading<Item>.Action)
	}
}

extension SingleSelector.State: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.pageLoading.loadingId == rhs.pageLoading.loadingId
	}
}
