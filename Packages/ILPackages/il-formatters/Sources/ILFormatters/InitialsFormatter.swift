public struct InitialsFormatter {
	public static let `default` = Self()
	
	public func format (name: String?, surname: String?, username: String) -> String {
		let nameInitial = name?.first.map(String.init) ?? ""
		let surnameInitial = surname?.first.map(String.init) ?? ""
		let nameSurnameInitial = nameInitial + surnameInitial
		
		let initials =
		if nameSurnameInitial.isEmpty {
			username.first.map(String.init) ?? ""
		} else {
			nameSurnameInitial
		}
		
		return initials
	}
}
