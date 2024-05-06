import ComposableArchitecture
import Foundation
import DLUtils

extension Transfers {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = Transfers.State
		public typealias Action = Transfers.Action

		public init () { }

		public var body: some ComposableArchitecture.Reducer<State, Action> {
			EmptyReducer()
		}
	}
}
