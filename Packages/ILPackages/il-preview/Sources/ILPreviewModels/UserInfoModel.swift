import ILModels

public extension UserInfoModel {
	static let ostap = Self(
		id: .init(),
		name: "Ostap",
		surname: "Bender",
		username: "ostap1",
		image: .init(systemName: "person.fill"),
		initials: "OB"
	)

	static let alexander = Self(
		id: .init(),
		name: "Alexander",
		surname: nil,
		username: "alexander",
		image: .init(systemName: "person.fill"),
		initials: "A"
	)

	static let daniel = Self(
		id: .init(),
		name: "Daniel",
		surname: nil,
		username: "daniel",
		image: .init(systemName: "person.fill"),
		initials: "D"
	)

	static let ignat = Self(
		id: .init(),
		name: "Ignat",
		surname: nil,
		username: "ignat",
		image: .init(systemName: "person.fill"),
		initials: "I"
	)

	static let valdis = Self(
		id: .init(),
		name: "Valdis",
		surname: nil,
		username: "valdis",
		image: .init(systemName: "person.fill"),
		initials: "V"
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
