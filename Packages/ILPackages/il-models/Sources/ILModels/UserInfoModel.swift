import SwiftUI

public struct UserInfoModel {
	public let id: UUID
	public let name: String?
	public let surname: String?
	public let username: String
	public let image: Image?
	public let initials: String

	public init (
		id: UUID,
		name: String?,
		surname: String?,
		username: String,
		image: Image?,
		initials: String
	) {
		self.id = id
		self.name = name
		self.surname = surname
		self.username = username
		self.image = image
		self.initials = initials // ?? InitialsFormatter.default.format(name: name, surname: surname, username: username)
	}
}

extension UserInfoModel: Hashable {
	public func hash (into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(name)
		hasher.combine(surname)
		hasher.combine(username)
		hasher.combine(initials)
	}
}

// MARK: - Preview data
public extension UserInfoModel {
	static let standard = Self(
		id: .init(),
		name: "Ostap",
		surname: "Bender",
		username: "ostap1",
		image: .init(systemName: "person.fill"),
		initials: "OB"
	)

	static let withoutImage = Self(
		id: .init(),
		name: "Ostap",
		surname: "Bender",
		username: "ostap2",
		image: nil,
		initials: "OB"
	)

	static let withoutName = Self(
		id: .init(),
		name: nil,
		surname: "Bender",
		username: "ostap3",
		image: nil,
		initials: "OB"
	)

	static let withoutSurname = Self(
		id: .init(),
		name: "Ostap",
		surname: nil,
		username: "ostap4",
		image: nil,
		initials: "OB"
	)

	static let withoutNameSurname = Self(
		id: .init(),
		name: nil,
		surname: nil,
		username: "ostap5",
		image: nil,
		initials: "OB"
	)

	static let all: [Self] = [
		.standard,
		.withoutImage,
		.withoutName,
		.withoutSurname,
		.withoutNameSurname
	]
}
