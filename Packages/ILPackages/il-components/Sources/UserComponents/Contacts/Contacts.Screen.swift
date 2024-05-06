import ILModels
import SwiftUI

public struct ContactsView: View {
	let contacts: [UserInfoModel]
	
	public init (contacts: [UserInfoModel]) {
		self.contacts = contacts
	}
	
	public var body: some View {
		ForEach(contacts, id: \.self) { contact in
			UserShortView(user: contact)
		}
	}
}
