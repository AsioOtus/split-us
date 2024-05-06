import SwiftUI

public extension Binding {
	func update (
		get: @escaping (Value) -> Value = { $0 },
		set: @escaping (Value) -> Value = { $0 }
	) -> Binding<Value> {
		.init(
			get: {
				get(self.wrappedValue)
			},
			set: {
				self.wrappedValue = set($0)
			}
		)
	}
}
