import SwiftUI

public extension Binding {
	func map <NewValue> (
		get: @escaping (Value) -> NewValue,
		set: @escaping (NewValue) -> Value
	) -> Binding<NewValue> {
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
