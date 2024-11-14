import DLModels
import ILFormatters
import ILModels

extension UserScreenModel {
	public struct Mapper {
		public static let `default` = Self()

		let initialFormatter = InitialsFormatter.default
		let uuidHsbaConverter = UUIDHSVAConverter.default
	}
}

public extension UserScreenModel.Mapper {
	func map (_ user: User.Compact) -> UserScreenModel {
		.init(
			id: user.id,
			name: user.name,
			surname: user.surname,
			username: user.username,
			image: nil,
			initials: initialFormatter.format(
				name: user.name,
				surname: user.surname,
				username: user.username
			),
			color: uuidHsbaConverter.convert(user.id).rgba
		)
	}
	
	func map (_ user: User) -> UserScreenModel {
		.init(
			id: user.id,
			name: user.name,
			surname: user.surname,
			username: user.username,
			image: nil,
			initials: initialFormatter.format(
				name: user.name,
				surname: user.surname,
				username: user.username
			),
			color: uuidHsbaConverter.convert(user.id).rgba
		)
	}
}
