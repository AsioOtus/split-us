import ComposableArchitecture
import DLModels
import DLUtils

public enum UserSummaries {
	public struct Reducer {
		public init () { }
	}
}

extension UserSummaries.Reducer: ComposableArchitecture.Reducer {
	public var body: some ComposableArchitecture.Reducer<State, Action> {
		EmptyReducer()
	}
}

extension UserSummaries.Reducer {
	@ObservableState
	public struct State: Equatable {
		public let summaries: [UserSummary]
		
		public init (summaries: [UserSummary]) {
			self.summaries = summaries
		}
	}
}

extension UserSummaries.Reducer {
	@CasePathable
	public enum Action { }
}
