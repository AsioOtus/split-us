import Foundation
import NetworkUtil

extension Requests {
	public struct Contacts: ModellableResponseRequest {
		public typealias ResponseModel = ContactsResponseModel
		
		public let path: String = "contacts"

		public init () { }
	}
}
