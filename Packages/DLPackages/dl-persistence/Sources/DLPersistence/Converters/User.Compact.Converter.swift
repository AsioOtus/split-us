import CoreData
import DLModels

extension User.Compact {
	struct Converter {
		static let `default` = Self()

		func convert (_ entity: UserEntity) -> User.Compact {
			.init(
				id: entity.id,
				username: entity.username,
				name: entity.name,
				surname: entity.surname
			)
		}

		@discardableResult
		func convert (_ user: User.Compact, cacheTimestamp: Date, entity: UserEntity) -> UserEntity {
			entity
				.set(
					id: user.id,
					username: user.username,
					name: user.name,
					surname: user.surname,
					acronym: "",
					isContact: false,
					cacheTimestamp: cacheTimestamp
				)

			return entity
		}
	}
}
