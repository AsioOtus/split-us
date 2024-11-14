import DLModels
import Foundation
import Multitool

public extension User.Compact {
	static func empty (id: UUID = .create(0)) -> Self {
		Self(id: id, username: "", name: "", surname: "")
	}

	static let ostap = Self(
		id: .create(1),
		username: "ostap",
		name: "Ostap",
		surname: "Bender"
	)

	static let alexander = Self(
		id: .create(2),
		username: "alexander",
		name: "Alexander",
		surname: nil
	)

	static let valdis = Self(
		id: .create(3),
		username: "valdis",
		name: "Valdis",
		surname: nil
	)

	static let ignat = Self(
		id: .create(4),
		username: "ignat",
		name: "Ignat",
		surname: nil
	)

	static let daniel = Self(
		id: .create(5),
		username: "daniel",
		name: "Daniel",
		surname: nil
	)

	static let sampleA = Self(
		id: .create(1, 0),
		username: "sampleA",
		name: "NameSampleA",
		surname: "SurnameSampleA"
	)

	static let sampleB = Self(
		id: .create(1, 1),
		username: "sampleB",
		name: "NameSampleB",
		surname: "SurnameSampleB"
	)
}
