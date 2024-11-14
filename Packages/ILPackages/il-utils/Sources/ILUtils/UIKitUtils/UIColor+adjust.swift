import UIKit

public extension UIColor {
	func lighter (percent: Double) -> Self {
		adjust(percent: percent)
	}

	func darker (percent: Double) -> Self {
		adjust(percent: -1 * percent)
	}

	func adjust (percent: Double) -> Self {
		let (red, green, blue, alpha) = rgba

		return .init(
			red: min(red + red * percent, 1.0),
			green: min(green + green * percent, 1.0),
			blue: min(blue + blue * percent, 1.0),
			alpha: alpha
		)
	}
}
