import SwiftUI

public extension Binding {
	func unwrap <T> (default: T) -> Binding<T> where Value == T?  {
		.init(
			get: { wrappedValue ?? `default` },
			set: { wrappedValue = $0 }
		)
	}

	func willSet (_ action: @escaping (Value) -> Void) -> Self {
		.init(
			get: { wrappedValue },
			set: {
				action($0)
				wrappedValue = $0
			}
		)
	}

	func didSet (_ action: @escaping (Value) -> Void) -> Self {
		.init(
			get: { wrappedValue },
			set: {
				let oldValue = wrappedValue
				wrappedValue = $0
				action(oldValue)
			}
		)
	}
}

public extension Binding where Value: Equatable {
	func ignoringDuplicates () -> Self {
		.init(
			get: { wrappedValue },
			set: {
				guard wrappedValue != $0 else { return }
				wrappedValue = $0
			}
		)
	}
}

public extension Binding where Value == Bool {
	func inverse () -> Self {
		.init(
			get: { !wrappedValue },
			set: { wrappedValue = !$0 }
		)
	}
}
