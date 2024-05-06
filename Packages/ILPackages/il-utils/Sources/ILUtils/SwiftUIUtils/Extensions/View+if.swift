import SwiftUI

public extension View {
	@ViewBuilder
	func `if` (
		_ condition: Bool,
		then: (Self) -> some View,
		else: (Self) -> some View = { (self: Self) in self }
	) -> some View {
		if condition {
			then(self)
		} else {
			`else`(self)
		}
	}
}
