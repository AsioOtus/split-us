import ComposableArchitecture
import DLModels
import Foundation

extension PageLoading {
	@Reducer
	public struct Reducer {
		public typealias State = PageLoading.State
		public typealias Action = PageLoading.Action

		@Dependency(\.networkConnectivityService) var networkConnectivityService

		let loadPage: (UUID, Page) async throws -> [Item]
		let loadPageLocal: (UUID, Page) throws -> [Item]

		public init (
			loadPage: @escaping (UUID, Page) async throws -> [Item],
			loadPageLocal: @escaping (UUID, Page) throws -> [Item]
		) {
			self.loadPage = loadPage
			self.loadPageLocal = loadPageLocal
		}

		public var body: some ReducerOf<Self> {
			Reduce { state, action in
				switch action {
				case .initialize: return initialize(&state)
				case .refresh: return refresh(&state)

				case .onItemDisplayed(let itemIndex): return onItemDisplayed(itemIndex, &state)

				case .loadPage(let page): return loadPage(page, &state)
				case .loadNextPage: return loadNextPage(&state)
				case .pageLoadingSuccess(let pageItems, let page): pageLoadingSuccess(pageItems, page, &state)
				case .pageLoadingFailure(let error, let page): pageLoadingFailure(error, page, &state)

				case .connectionState(.refreshCompleted): return connectionStateRefreshCompleted(&state)
				case .connectionState: break
				}

				return .none
			}

			Scope(state: \.connectionState, action: \.connectionState) {
				ConnectionStateFeature.Reducer()
			}
		}
	}
}

private extension PageLoading.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		guard !state.isLoading, state.items.isEmpty, state.currentPage == -1 else { return .none }
		return load(0, &state)
			.merge(with: .run { await $0(.connectionState(.initialize)) })
	}

	func refresh (_ state: inout State) -> Effect<Action> {
		state.isRefreshing = true
		return load(0, &state)
	}

	func onItemDisplayed (_ item: PageItem<Item>, _ state: inout State) -> Effect<Action> {
		guard
			state.items.count - item.index <= state.remainingBeforeLoadingThreshold,
			!state.isLastLoaded
		else { return .none }

		return .run { await $0(.loadNextPage) }
	}

	func loadNextPage (_ state: inout State) -> Effect<Action> {
		.run { [state] in await $0(.loadPage(state.currentPage + 1)) }
	}

	func loadPage (_ page: Int, _ state: inout State) -> Effect<Action> {
		load(page, &state)
	}

	func pageLoadingSuccess (_ pageItems: [PageItem<Item>], _ page: Page, _ state: inout State) {
		state.isRefreshing = false
		state.isLoading = false
		state.error = nil

		addItems(pageItems, page, false, &state)

		state.isLastLoaded = pageItems.count < state.pageSize
	}

	func pageLoadingFailure (_ error: Error, _ page: Page, _ state: inout State) {
		state.isRefreshing = false
		state.isLoading = false
		state.items.removeAll { $0.page.number >= page.number }
		state.error = error

		if networkConnectivityService.state(error: error).isOffline {
			loadLocal(page.number, &state)
		}
	}

	func connectionStateRefreshCompleted (_ state: inout State) -> Effect<Action> {
		guard state.connectionState.connectionState.isOnline else { return .none }
		return .run { await $0(.refresh) }
	}
}

private extension PageLoading.Reducer {
	func load (_ pageNumber: Int, _ state: inout State) -> Effect<Action> {
		guard !state.isLoading else { return .none }
		state.isLoading = true

		let page = Page(number: pageNumber, size: state.pageSize)

		return .run { [state] send in
			var lastItemIndex = state.items.endIndex - 1
			let pageItems = try await loadPage(state.loadingId, page)
				.map {
					lastItemIndex += 1
					return PageItem(page: page, index: lastItemIndex, item: $0)
				}

			await send(.pageLoadingSuccess(pageItems, page))
		} catch: { error, send in
			await send(.pageLoadingFailure(error, page))
		}
	}

	func loadLocal (_ pageNumber: Int, _ state: inout State) {
		let page = Page(
			number: pageNumber,
			size: state.pageSize
		)

		let lastItemIndex = state.items.endIndex - 1
		guard
			let pageItems = try? loadPageLocal(state.loadingId, page)
				.enumerated()
				.map({ PageItem(page: page, index: lastItemIndex + $0, item: $1) })
		else { return }

		if !pageItems.isEmpty {
			addItems(pageItems, page, true, &state)
			state.error = nil
		}

		state.isLastLoaded = pageItems.count < state.pageSize
	}

	func addItems (_ pageItems: [PageItem<Item>], _ page: Page, _ isLocal: Bool, _ state: inout State) {
		guard !isLocal || isLocal && pageItems.contains(where: { $0.page.number == page.number }) else { return }

		state.items.removeAll { $0.page.number >= page.number }

		if !pageItems.isEmpty {
			state.items.append(contentsOf: pageItems)
			state.currentPage = page.number
		}
	}
}
