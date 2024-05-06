import DLModels
import Foundation
import Multitool

public extension User.Compact {
	static func empty (id: UUID = .create(0)) -> Self {
		Self(id: id, username: "", name: "", surname: "")
	}

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
