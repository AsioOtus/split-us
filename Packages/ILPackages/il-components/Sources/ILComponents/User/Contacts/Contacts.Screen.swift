import ILModels
import SwiftUI

public struct ContactsView: View {
	let contacts: [UserScreenModel]
	
	public init (contacts: [UserScreenModel]) {
		self.contacts = contacts
	}
	
	public var body: some View {
		ForEach(contacts, id: \.self) { contact in
			UserShortView(user: contact)
		}
	}
}
