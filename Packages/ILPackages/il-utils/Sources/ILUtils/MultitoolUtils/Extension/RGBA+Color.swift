import Multitool
import SwiftUI

public extension RGBA {
	var color: Color {
		.init(
			red: red,
			green: green,
			blue: blue
		)
		.opacity(alpha)
	}
}
