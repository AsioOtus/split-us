import ILFormatters
import SwiftUI

public struct UserUsernameView: View {
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
		UserUsernameView(username: "ostap")
			.controlSize(.small)
		
		UserUsernameView(username: "ostap")
			.controlSize(.regular)
		
		UserUsernameView(username: "ostap")
	}
}
