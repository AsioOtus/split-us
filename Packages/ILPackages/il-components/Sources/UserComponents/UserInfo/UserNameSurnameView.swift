import SwiftUI

public struct UserNameSurnameView: View {
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
		HStack(spacing: 4) {
			if let name {
				Text(name)
			}

			if let surname {
				Text(surname)
			}
		}
	}
}

#Preview {
	UserNameSurnameView(name: "Ostap", surname: "Bender")
}
