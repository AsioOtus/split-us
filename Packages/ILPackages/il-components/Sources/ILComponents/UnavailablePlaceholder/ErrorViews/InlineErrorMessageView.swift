import SwiftUI

public struct InlineErrorMessageView: View {
	let message: LocalizedStringKey
	
	public init (message: LocalizedStringKey) {
		self.message = message
	}
	
	public var body: some View {
		Text(message)
			.foregroundStyle(.red.secondary)
	}
}
