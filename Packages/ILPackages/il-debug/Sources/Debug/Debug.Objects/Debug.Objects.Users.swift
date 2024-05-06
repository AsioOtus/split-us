import DLModels
import Foundation

extension User {
	init (id: UUID, name: String) {
		self.init(
			id: id,
			name: name,
			surname: "",
			email: "",
			username: ""
		)
	}
}

extension User.Compact {
	init (id: UUID, name: String) {
		self.init(
			id: id,
			username: name,
			name: nil,
			surname: nil
		)
	}
}

extension Debug.Objects {
	public struct Users {
		public static let `default` = Self()
		
		public let ostap: User     = .init(id: .create(1, 1), name: "Остап")
		public let alexander: User = .init(id: .create(1, 2), name: "Александр")
		public let boris: User     = .init(id: .create(1, 3), name: "Борис")
		public let daniel: User    = .init(id: .create(1, 4), name: "Даниэль")
		public let ilja: User      = .init(id: .create(1, 5), name: "Илья")
		public let max: User       = .init(id: .create(1, 6), name: "Максим")
		public let valdis: User    = .init(id: .create(1, 7), name: "Валдис")
		
		public let anastasia: User = .init(id: .create(2, 1), name: "Анастасия")
		public let daniil: User    = .init(id: .create(2, 2), name: "Даниил")
		public let jana: User      = .init(id: .create(2, 3), name: "Яна")
		
		public var all: [User] {
			[
				alexander,
				boris,
				daniel,
				ilja,
				max,
				ostap,
				valdis,
				anastasia,
				daniil,
				jana
			]
		}
	}
}

public extension User.Compact {
	static let ostap: Self     = .init(id: .create(1, 1), name: "Остап")
	static let alexander: Self = .init(id: .create(1, 2), name: "Александр")
	static let boris: Self     = .init(id: .create(1, 3), name: "Борис")
	static let daniel: Self    = .init(id: .create(1, 4), name: "Даниэль")
	static let ilja: Self      = .init(id: .create(1, 5), name: "Илья")
	static let max: Self       = .init(id: .create(1, 6), name: "Максим")
	static let valdis: Self    = .init(id: .create(1, 7), name: "Валдис")
	
	static let anastasia: Self = .init(id: .create(2, 1), name: "Анастасия")
	static let daniil: Self    = .init(id: .create(2, 2), name: "Даниил")
	static let jana: Self      = .init(id: .create(2, 3), name: "Яна")
	
	static var all: [Self] {
		[
			.ostap,
			.alexander,
			.boris,
			.daniel,
			.ilja,
			.max,
			.valdis,
			.anastasia,
			.daniil,
			.jana
		]
	}
}
