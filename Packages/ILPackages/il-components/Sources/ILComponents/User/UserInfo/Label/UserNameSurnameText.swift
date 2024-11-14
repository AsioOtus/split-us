import ILFormatters
import SwiftUI

public struct UserNameSurnameText: View {
	private let nameSurnameFormatter = UserNameSurnameFormatter.default

	let name: String?
	let surname: String?

	public init (
		name: String?,
		surname: String?
	) {
		self.name = name
		self.surname = surname
	}

	public var body: some View {
		Text(nameSurnameFormatter.format(name: name, surname: surname) ?? "")
	}
}

#Preview {
	UserNameSurnameText(name: "Ostap", surname: "Bender")
}
