import ILFormatters
import SwiftUI

public struct UserNameUsernameText: View {
	let usernameFormatter = UsernameFormatter.default

	let name: String?
	let surname: String?
	let username: String

	var nameSurnameText: String? {
		let text = [name, surname].compactMap { $0 }.joined(separator: " ")
		return text.isEmpty ? nil : text
	}

	var text: String {
		nameSurnameText ?? usernameFormatter.format(username)
	}

	public init (
		name: String?,
		surname: String?,
		username: String
	) {
		self.name = name
		self.surname = surname
		self.username = username
	}

	public var body: some View {
		Text(text)
	}
}
