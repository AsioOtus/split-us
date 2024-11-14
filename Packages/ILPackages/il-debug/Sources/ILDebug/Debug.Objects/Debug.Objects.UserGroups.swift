import DLModels

extension Debug.Objects {
	struct UserGroups {
		static let `default` = Self()
		
		let prague = UserGroup(id: .create(1), name: "Прага", defaultCurrency: .eur)
		let oslo = UserGroup(id: .create(2), name: "Осло", defaultCurrency: .eur)
		let cruise = UserGroup(id: .create(3), name: "Круиз", defaultCurrency: .eur)
		
		var all: [UserGroup] {
			[
				prague,
				oslo,
				cruise
			]
		}
	}
}
