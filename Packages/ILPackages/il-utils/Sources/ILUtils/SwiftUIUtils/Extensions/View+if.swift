import SwiftUI

public extension View {
	@ViewBuilder
	func `if` (
		_ condition: Bool,
		then: (Self) -> some View
	) -> some View {
		if condition {
			then(self)
		} else {
			self
		}
	}

	@ViewBuilder
	func `if` (
		_ condition: Bool,
		then: (Self) -> some View,
		else: (Self) -> some View
	) -> some View {
		if condition {
			then(self)
		} else {
			`else`(self)
		}
	}
}
