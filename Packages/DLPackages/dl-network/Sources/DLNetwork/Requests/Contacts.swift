import Foundation
import NetworkUtil

extension Requests {
	public struct Contacts: ModellableResponseRequest {
		public typealias ResponseModel = ContactsResponseModel

		public var configuration: RequestConfiguration {
			.init()
			.setPath("contacts")
		}

		public init () { }
	}
}
