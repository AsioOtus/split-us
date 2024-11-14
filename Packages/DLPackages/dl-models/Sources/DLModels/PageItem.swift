public struct PageItem <Item> {
	public let page: Page
	public let index: Int
	public let item: Item

	public init (page: Page, index: Int, item: Item) {
		self.page = page
		self.index = index
		self.item = item
	}
}

extension PageItem: Equatable where Item: Equatable { }
extension PageItem: Hashable where Item: Hashable { }
