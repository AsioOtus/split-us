import DLModels
import ILFormatters
import ILModels

extension UserInfoModel {
	public struct Mapper {
		public static let `default` = Self()
	}
}

public extension UserInfoModel.Mapper {
	func map (_ user: User.Compact) -> UserInfoModel {
		.init(
			id: user.id,
			name: user.name,
			surname: user.surname,
			username: user.username,
			image: nil,
			initials: InitialsFormatter.default.format(
				name: user.name,
				surname: user.surname,
				username: user.username
			)
		)
	}
	
	func map (_ user: User) -> UserInfoModel {
		.init(
			id: user.id,
			name: user.name,
			surname: user.surname,
			username: user.username,
			image: nil,
			initials: InitialsFormatter.default.format(
				name: user.name,
				surname: user.surname,
				username: user.username
			)
		)
	}
}
