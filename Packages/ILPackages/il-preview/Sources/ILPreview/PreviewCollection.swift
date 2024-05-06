import SwiftUI

public struct PreviewCollection <C, ContentView>: View
where C: RandomAccessCollection, C.Element: Hashable, ContentView: View {
	public let collection: C
	public let contentView: (C.Element) -> ContentView

	public init (
		_ collection: C,
		contentView: @escaping (C.Element) -> ContentView
	) {
		self.collection = collection
		self.contentView = contentView
	}

	public var body: some View {
		VStack {
			ForEach(collection, id: \.self) {
				contentView($0)
			}
		}
	}
}
