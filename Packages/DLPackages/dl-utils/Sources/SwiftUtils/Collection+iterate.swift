public extension Collection {
	func iterate (where filter: (Index) -> Bool, _ action: (Index) -> Void) {
		for i in indices where filter(i) {
			action(i)
		}
	}

	func iterate (where filter: () -> Bool, _ action: (Index) -> Void) {
		for i in indices where filter() {
			action(i)
		}
	}
}
