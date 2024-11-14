import ComposableArchitecture
import DLModels
import DLServices
import Foundation

extension SingleSelector {
	@Reducer
	public struct Reducer {
		public typealias State = SingleSelector.State
		public typealias Action = SingleSelector.Action

		@Dependency(\.dismiss) var dismiss

		let loadPage: (UUID, Page) async throws -> [Item]
		let loadPageLocal: (UUID, Page) throws -> [Item]

		public init(
			loadPage: @escaping (UUID, Page) async throws -> [Item],
			loadPageLocal: @escaping (UUID, Page) throws -> [Item]
		) {
			self.loadPage = loadPage
			self.loadPageLocal = loadPageLocal
		}

		public var body: some ReducerOf<Self> {
			BindingReducer()

			Reduce { state, action in
				switch action {
				case .binding: break

				case .onListButtonTap: onListButtonTap(&state)
				case .itemSelected(let item): return itemSelected(item, &state)

				case .pageLoading: break
				}

				return .none
			}

			Scope(state: \.pageLoading, action: \.pageLoading) {
				PageLoading.Reducer(loadPage: loadPage, loadPageLocal: loadPageLocal)
			}
		}
	}
}

private extension SingleSelector.Reducer {
	func onListButtonTap (_ state: inout State) {
		state.isListPresented.toggle()
	}

	func itemSelected (_ pageItem: PageItem<Item>?, _ state: inout State) -> Effect<Action> {
		state.selectedPageItem = pageItem
		state.isListPresented = false
		return .none
	}
}
