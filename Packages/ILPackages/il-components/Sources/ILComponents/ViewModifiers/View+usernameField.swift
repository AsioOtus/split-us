import SwiftUI

public extension View {
	func usernameField () -> some View {
		self
			.keyboardType(.asciiCapable)
			.textInputAutocapitalization(.never)
			.disableAutocorrection(true)
	}
}
