import ILFormatters
import SwiftUI

public struct UserUsernameText: View {
	@Environment(\.controlSize) private var controlSize
	
	private let usernameFormatter = UsernameFormatter.default
	
	let username: String

	public init (username: String) {
		self.username = username
	}

	public var body: some View {
		Text(usernameFormatter.format(username))
			.foregroundStyle(.tint)
			.font(controlSize.usernameFont)
	}
}

#Preview {
	VStack {
		UserUsernameText(username: "ostap")
			.controlSize(.small)
		
		UserUsernameText(username: "ostap")
			.controlSize(.regular)
		
		UserUsernameText(username: "ostap")
	}
}
