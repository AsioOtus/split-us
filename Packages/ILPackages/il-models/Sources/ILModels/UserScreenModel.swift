import Multitool
import SwiftUI

public struct UserScreenModel {
	public let id: UUID
	public let name: String?
	public let surname: String?
	public let username: String
	public let image: Image?
	public let initials: String
	public let color: RGBA

	public init (
		id: UUID,
		name: String?,
		surname: String?,
		username: String,
		image: Image?,
		initials: String,
		color: RGBA
	) {
		self.id = id
		self.name = name
		self.surname = surname
		self.username = username
		self.image = image
		self.initials = initials
		self.color = color
	}
}

extension UserScreenModel: Hashable {
	public func hash (into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(name)
		hasher.combine(surname)
		hasher.combine(username)
		hasher.combine(initials)
	}
}
