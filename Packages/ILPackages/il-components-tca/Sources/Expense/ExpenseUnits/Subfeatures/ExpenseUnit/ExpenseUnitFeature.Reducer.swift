import ComposableArchitecture

extension ExpenseUnitFeature {
	@Reducer
	public struct Reducer {
		public typealias State = ExpenseUnitFeature.State
		public typealias Action = ExpenseUnitFeature.Action

		public init () { }

		public var body: some ReducerOf<ExpenseUnitFeature.Reducer> {
			EmptyReducer()
				.ifCaseLet(\.expense, action: \.expense) {
					ExpenseFeature.Reducer()
				}
				.ifCaseLet(\.expenseGroup, action: \.expenseGroup) {
					ExpenseGroupFeature.Reducer()
				}
		}
	}
}
