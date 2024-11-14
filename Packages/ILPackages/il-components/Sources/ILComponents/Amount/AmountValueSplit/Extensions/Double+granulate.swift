import Foundation

public extension Double {
	func granulate (
		step: Double
	) -> Self {
		let count = (self / step).rounded(.down)
		let result = step * count
		return result
	}
}
