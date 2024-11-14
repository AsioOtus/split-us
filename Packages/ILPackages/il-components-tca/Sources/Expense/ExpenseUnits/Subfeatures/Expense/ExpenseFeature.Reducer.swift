import ComposableArchitecture

extension ExpenseFeature {
	@Reducer
	public struct Reducer {
		public typealias State = ExpenseFeature.State
		public typealias Action = ExpenseFeature.Action
	}
}
