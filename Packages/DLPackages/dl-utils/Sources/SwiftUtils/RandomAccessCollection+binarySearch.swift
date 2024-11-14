public extension RandomAccessCollection {
	func binarySearch (predicate: (Element) -> Bool) -> Index {
		var left = startIndex
		var right = endIndex

		while left != right {
			let middle = index(left, offsetBy: distance(from: left, to: right) / 2)

			if predicate(self[middle]) {
				left = index(after: middle)
			} else {
				right = middle
			}
		}

		return left
	}
}
