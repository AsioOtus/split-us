public extension Double {
	func int (_ multiplier: Double = 1) -> Int {
		.init(self * multiplier)
	}
}
