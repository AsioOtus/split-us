import ComposableArchitecture
import DLLogic

extension Profile {
	@Reducer
	public struct Reducer: ComposableArchitecture.Reducer {
		public typealias State = Profile.State
		public typealias Action = Profile.Action

		@Dependency(\.logoutEventChannel) var logoutEventChannel

		public init () { }

		public var body: some ComposableArchitecture.Reducer<State, Action> {
			Reduce { _, action in
				switch action {
				case .logout:
					return .run { _ in
						await logoutEventChannel.send(.logout(.userAction))
					}
				}
			}
		}
	}
}
