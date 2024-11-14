import ComposableArchitecture
import DLServices

extension ExpenseGroupFeature {
	@Reducer
	public struct Reducer {
		public typealias State = ExpenseGroupFeature.State
		public typealias Action = ExpenseGroupFeature.Action

		public var body: some ReducerOf<ExpenseGroupFeature.Reducer> {
			BindingReducer()
			
			Reduce { state, action in
				switch action {
				case .binding(\.isExpanded): return bindingIsExpanded(&state)

				default: break
				}

				return .none
			}

			Scope(state: \.expenseUnits, action: \.expenseUnits) {
				ExpenseUnitsFeature.Reducer()
			}
		}
	}
}

private extension ExpenseGroupFeature.Reducer {
	func bindingIsExpanded (_ state: inout State) -> Effect<Action> {
		if state.isExpanded {
			.send(.expenseUnits(.initialize))
		} else {
			.none
		}
	}
}
