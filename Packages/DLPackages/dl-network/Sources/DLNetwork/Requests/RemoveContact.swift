import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct RemoveContactRequest: ModellableResponseRequest {
		public typealias Body = RemoveContactRequestModel
		public typealias ResponseModel = SharedResponseModels.Success
		
		public var method: HTTPMethod { .post }
		public var path: String { "contacts/removeContact" }
		public var body: Body?
		
		public init (_ body: Body) {
			self.body = body
		}
	}
}

public extension Requests.RemoveContactRequest {
	init (
		userId: UUID
	) {
		self.body = .init(
			userId: userId
		)
	}
}
