import SwiftUI

public struct CurrentUserScreenModel {
	public let name: String?
	public let surname: String?
	public let username: String
	public let email: String?
	public let image: Image?
	public let initials: String
	public let color: Color

	public init (
		name: String?,
		surname: String?,
		username: String,
		email: String?,
		image: Image?,
		initials: String,
		color: Color
	) {
		self.name = name
		self.surname = surname
		self.username = username
		self.email = email
		self.image = image
		self.initials = initials
		self.color = color
	}
}

// MARK: - Preview data
public extension CurrentUserScreenModel {
	static let standard = Self(
		name: "Ostap",
		surname: "Bender",
		username: "ostap1",
		email: "ostap1@email.net",
		image: .init(systemName: "person.fill"),
		initials: "OB",
		color: .red
	)
	
	static let withoutImage = Self(
		name: "Ostap",
		surname: "Bender",
		username: "ostap2",
		email: "ostap2@email.net",
		image: nil,
		initials: "OB",
		color: .red
	)
	
	static let withoutName = Self(
		name: nil,
		surname: "Bender",
		username: "ostap3",
		email: "ostap3@email.net",
		image: nil,
		initials: "OB",
		color: .red
	)
	
	static let withoutSurname = Self(
		name: "Ostap",
		surname: nil,
		username: "ostap4",
		email: "ostap4@email.net",
		image: nil,
		initials: "OB",
		color: .red
	)
	
	static let withoutNameSurname = Self(
		name: nil,
		surname: nil,
		username: "ostap5",
		email: "ostap5@email.net",
		image: nil,
		initials: "OB",
		color: .red
	)
	
	static let all: [Self] = [
		.standard,
		.withoutImage,
		.withoutName,
		.withoutSurname,
		.withoutNameSurname
	]
}
