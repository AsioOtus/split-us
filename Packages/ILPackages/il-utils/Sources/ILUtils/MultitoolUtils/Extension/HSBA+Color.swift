import Multitool
import SwiftUI

public extension HSVA {
	var color: Color {
		.init(
			hue: hue,
			saturation: saturation,
			brightness: value
		)
		.opacity(alpha)
	}
}
