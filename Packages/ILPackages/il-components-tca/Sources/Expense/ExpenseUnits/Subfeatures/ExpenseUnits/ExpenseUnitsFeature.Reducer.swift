import ComposableArchitecture
import DLModels
import DLServices
import Foundation
import SwiftUtils

extension ExpenseUnitsFeature {
	@Reducer
	public struct Reducer {
		public typealias State = ExpenseUnitsFeature.State
		public typealias Action = ExpenseUnitsFeature.Action

		@Dependency(\.expenseService) var expenseService
		@Dependency(\.expenseLocalService) var expenseLocalService
		@Dependency(\.expenseUnitsEventChannel) var expenseUnitsEventChannel

		public init () { }

		public var body: some ReducerOf<ExpenseUnitsFeature.Reducer> {
			Reduce { state, action in
				switch action {
				case .initialize: return initialize(&state)
				case .refresh: return refresh(&state)

				case .onFirstPage: return onFirstPage(&state)
				case .onNextPage: return onNextPage(&state)
				case .onExpenseUnitsLoadingSuccess(let expenseUnits, let page): onExpenseUnitsLoadingSuccess(expenseUnits, page, &state)
				case .onExpenseUnitsLoadingFailure(let error, let page): onExpenseUnitsLoadingFailure(error, page, &state)

				case .expenseUnitEvent(.expenseGroupAdded(let expenseGroup, let superExpenseGroupId)): insertExpenseGroup(expenseGroup, superExpenseGroupId, &state)
				case .expenseUnitEvent(.expenseGroupDeleted(let expenseGroup)): removeExpenseGroup(expenseGroup, &state)

				default: break
				}

				return .none
			}
			.forEach(\.expenseUnits, action: \.expenseUnits) {
				ExpenseUnitFeature.Reducer()
			}
		}
	}
}

private extension ExpenseUnitsFeature.Reducer {
	func initialize (_ state: inout State) -> Effect<Action> {
		guard state.currentPage == -1 && !state.isLoading else { return .none }
		return .merge(
			loadPage(0, &state),
			subscribeOnExpenseUnitsEventChannel()
		)
	}

	func refresh (_ state: inout State) -> Effect<Action> {
		guard state.currentPage == -1 && !state.isLoading else { return .none }
		return loadPage(0, &state)
	}

	func onFirstPage (
		_ state: inout State
	) -> Effect<Action> {
		guard state.currentPage == 0 && state.isLoading == false else { return .none }
		return loadPage(state.currentPage + 1, &state)
	}

	func onNextPage (
		_ state: inout State
	) -> Effect<Action> {
		loadPage(state.currentPage + 1, &state)
	}

	func onExpenseUnitsLoadingSuccess (_ expenseUnits: [ExpenseUnit.Default], _ page: Page, _ state: inout State) {
		state.isLoading = false
		addLoadedExpenseUnits(expenseUnits, page, &state)
	}

	func onExpenseUnitsLoadingFailure (_ error: Error, _ page: Page, _ state: inout State) {
		state.isLoading = false
		loadPageLocal(page.number, &state)
	}
}

private extension ExpenseUnitsFeature.Reducer {
	func loadPage (
		_ page: Int,
		_ state: inout State
	) -> Effect<Action> {
		let page = Page(
			number: page,
			size: state.pageSize
		)

		state.isLoading = true

		return .run { [state] send in
			let expenseUnits = if let superExpenseGroupId = state.superExpenseGroupId {
				try await expenseService.expenseUnits(
					expenseGroupId: superExpenseGroupId,
					page: page
				)
			} else {
				try await expenseService.expenseUnits(
					userGroupId: state.userGroupId,
					page: page
				)
			}

			await send(.onExpenseUnitsLoadingSuccess(expenseUnits, page))
		} catch: { error, send in
			await send(.onExpenseUnitsLoadingFailure(error, page))
		}
	}

	func loadPageLocal (
		_ page: Int,
		_ state: inout State
	) {
		let page = Page(
			number: page,
			size: state.pageSize
		)

		let expenseUnits = if let superExpenseGroupId = state.superExpenseGroupId {
			try? expenseLocalService.expenseUnits(
				expenseGroupId: superExpenseGroupId,
				page: page
			)
		} else {
			try? expenseLocalService.expenseUnits(
				userGroupId: state.userGroupId,
				page: page
			)
		}

		guard let expenseUnits else { return }

		addLoadedExpenseUnits(expenseUnits, page, &state)
	}

	func addLoadedExpenseUnits (
		_ expenseUnits: [ExpenseUnit.Default],
		_ page: Page,
		_ state: inout State
	) {
		let expenseUnitStates: [ExpenseUnitFeature.State] = expenseUnits.map {
			switch $0 {
			case .expense(let expense):
				.expense(
					.init(
						expense: expense,
						page: page,
						superExpenseGroupId: state.superExpenseGroupId,
						userGroupId: state.userGroupId
					)
				)

			case .expenseGroup(let expenseGroup):
				.expenseGroup(
					.init(
						expenseGroup: expenseGroup,
						page: page,
						superExpenseGroupId: state.superExpenseGroupId,
						userGroupId: state.userGroupId
					)
				)
			}
		}

		state.expenseUnits.removeAll { $0.page.number >= page.number }

		if !expenseUnits.isEmpty {
			state.expenseUnits.append(contentsOf: expenseUnitStates)
			state.currentPage = page.number
		}
	}

	func subscribeOnExpenseUnitsEventChannel () -> Effect<Action> {
		.publisher { expenseUnitsEventChannel.map(Action.expenseUnitEvent) }
	}

	func insertExpenseGroup (
		_ expenseGroup: ExpenseGroup,
		_ superExpenseGroupId: UUID?,
		_ state: inout State
	) {
		guard state.superExpenseGroupId == superExpenseGroupId else { return }

		let index = if let newDate = expenseGroup.info.date {
			state.expenseUnits.firstIndex {
				guard let date = $0.date else { return true }
				return newDate > date
			}
		} else {
			state.expenseUnits.firstIndex { $0.date == nil }
		}

		if let index {
			let expenseUnitState = state.expenseUnits[index]

			let newExpenseUnitState = ExpenseUnitFeature.State.expenseGroup(
				.init(
					expenseGroup: expenseGroup,
					page: expenseUnitState.page,
					superExpenseGroupId: superExpenseGroupId,
					userGroupId: state.userGroupId
				)
			)

			state.expenseUnits.insert(newExpenseUnitState, at: index)
		} else {
			let newExpenseUnitState = ExpenseUnitFeature.State.expenseGroup(
				.init(
					expenseGroup: expenseGroup,
					page: .init(number: 0, size: state.pageSize),
					superExpenseGroupId: superExpenseGroupId,
					userGroupId: state.userGroupId
				)
			)

			state.expenseUnits.insert(newExpenseUnitState, at: 0)
		}
	}

	func removeExpenseGroup (_ expenseGroup: ExpenseGroup, _ state: inout State) {
		state.expenseUnits.removeAll { $0.id == expenseGroup.id }
	}
}
