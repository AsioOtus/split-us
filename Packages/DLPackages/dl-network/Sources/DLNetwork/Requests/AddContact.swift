import DLModels
import Foundation
import NetworkUtil

extension Requests {
	public struct AddContactRequest: ModellableResponseRequest {
		public typealias Body = AddContactRequestModel
		public typealias ResponseModel = SharedResponseModels.Success

		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.post)
			.setPath("contacts/addContact")
		}

		public var body: Body?

		public init (_ body: Body) {
			self.body = body
		}
	}
}

public extension Requests.AddContactRequest {
	init (
		userId: UUID
	) {
		self.body = .init(
			userId: userId
		)
	}
}
