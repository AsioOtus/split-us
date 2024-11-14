import ComposableArchitecture
import DLModels
import Foundation

public enum PageLoading <Item: Hashable> {
	@ObservableState
	public struct State {
		public let loadingId: UUID
		public let pageSize: Int
		public let remainingBeforeLoadingThreshold: Int

		public var currentPage: Int = -1
		public var items: [PageItem<Item>] = []

		public var isRefreshing: Bool = false
		public var isLoading: Bool = false
		public var isLastLoaded: Bool = false

		public var error: Error?

		public var connectionState: ConnectionStateFeature.State = .init()

		public init (
			loadingId: UUID,
			pageSize: Int = 50,
			remainingBeforeLoadingThreshold: Int = 10
		) {
			self.loadingId = loadingId
			self.pageSize = pageSize
			self.remainingBeforeLoadingThreshold = remainingBeforeLoadingThreshold
		}
	}

	@CasePathable
	public enum Action {
		case initialize
		case refresh

		case onItemDisplayed(PageItem<Item>)

		case loadPage(Int)
		case loadNextPage
		case pageLoadingSuccess([PageItem<Item>], Page)
		case pageLoadingFailure(Error, Page)

		case connectionState(ConnectionStateFeature.Action)
	}
}
