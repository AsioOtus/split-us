public struct Page {
	public var number: Int
	public let size: Int

	public init (
		number: Int,
		size: Int
	) {
		self.number = number
		self.size = size
	}
}

public extension Page {
	func set (number: Int) -> Self {
		.init(number: number, size: size)
	}

	func set (size: Int) -> Self {
		.init(number: number, size: size)
	}
}

extension Page: Hashable { }
