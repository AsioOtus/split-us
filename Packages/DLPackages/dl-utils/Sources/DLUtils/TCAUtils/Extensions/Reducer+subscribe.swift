import AsyncAlgorithms
import ComposableArchitecture

public extension Reducer {
	func subscribe <T> (
		to values: AsyncChannel<T>,
		action: @escaping (T) -> Action
	) -> Effect<Action> {
		.run { send in
			for await value in values {
				await send(action(value))
			}
		}
	}
}
