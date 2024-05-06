import Combine
import ComposableArchitecture

@ObservableState
public struct Loading<Value> {
	public var previousValue: Value?

	public init (previousValue: Value? = nil) {
		self.previousValue = previousValue
	}
}

extension Loading: Equatable where Value: Equatable { }

extension Loading {
	func mapValue <NewValue> (mapping: (Value) -> NewValue) -> Loading<NewValue> {
		.init(
			previousValue: previousValue.map(mapping)
		)
	}

	func mapValue <NewValue> (mapping: (Value) throws -> NewValue) rethrows -> Loading<NewValue> {
		.init(
			previousValue: try previousValue.map(mapping)
		)
	}
}

extension Loadable {
	typealias LoadingTask<T> = LoadingValue<Effect<T>>

	public struct LoadingValue <Meta> {
		public let previousValue: Successful?
		public let meta: Meta?

		public init (
			previousValue: Successful?,
			meta: Meta?
		) {
			self.previousValue = previousValue
			self.meta = meta
		}
	}
}
