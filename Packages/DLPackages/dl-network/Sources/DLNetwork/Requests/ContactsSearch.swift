import Foundation
import NetworkUtil

extension Requests {
	public struct ContactSearch: ModellableResponseRequest {
		public typealias Body = ContactSearchRequestModel
		public typealias ResponseModel = ContactSearchResponseModel
		
		public var method: HTTPMethod { .post }
		public var path: String { "contacts/search" }
		public var body: Body?

		public init (_ body: Body) {
			self.body = body
		}
	}
}
