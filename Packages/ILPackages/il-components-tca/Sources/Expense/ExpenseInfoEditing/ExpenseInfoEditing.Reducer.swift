import ComponentsTCAMap
import ComposableArchitecture

extension ExpenseInfoEditing {
	@Reducer
	public struct Reducer {
		public typealias State = ExpenseInfoEditing.State
		public typealias Action = ExpenseInfoEditing.Action

		public init () { }

		public var body: some ReducerOf<Self> {
			BindingReducer()

			Reduce { state, action in
				return .none
			}

			Scope(state: \.expenseMap, action: \.expenseMap) {
				ExpenseMap()
			}
		}
	}
}
