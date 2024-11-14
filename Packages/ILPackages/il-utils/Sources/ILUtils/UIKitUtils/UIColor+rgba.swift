import UIKit

public extension UIColor {
	var rgba: (red: Double, green: Double, blue: Double, alpha: Double) {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var alpha: CGFloat = 0

		getRed(
			&r,
			green: &g,
			blue: &b,
			alpha: &alpha
		)

		return (r, g, b, alpha)
	}

	var redComponent: Double { rgba.red }
	var greenComponent: Double { rgba.green }
	var blueComponent: Double { rgba.blue }

	var alpha: Double { rgba.alpha }

	func set (
		red: Double? = nil,
		green: Double? = nil,
		blue: Double? = nil,
		alpha: Double? = nil
	) -> Self {
		.init(
			red: red ?? rgba.red,
			green: green ?? rgba.green,
			blue: blue ?? rgba.blue,
			alpha: alpha ?? rgba.alpha
		)
	}

	func setRGB (alpha: Double) -> Self {
		set(
			red: nil,
			green: nil,
			blue: nil,
			alpha: alpha
		)
	}

	func set (alpha: Double) -> Self {
		set(
			red: nil,
			green: nil,
			blue: nil,
			alpha: alpha
		)
	}
}
