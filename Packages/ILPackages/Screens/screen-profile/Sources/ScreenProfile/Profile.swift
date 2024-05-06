import ComposableArchitecture
import DLModels
import DLUtils

public enum Profile { }

extension Profile {
	@ObservableState
	public struct State: Equatable {
		public let user: User
		
		public init (user: User) {
			self.user = user
		}
	}
}

extension Profile {
	public enum Action {
		case logout
	}
}
