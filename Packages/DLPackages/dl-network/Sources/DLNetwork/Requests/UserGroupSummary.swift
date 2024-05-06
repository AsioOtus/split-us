import Foundation
import NetworkUtil

extension Requests {
	public struct UserGroupSummary: ModellableResponseRequest {
		public typealias Body = UserGroupSummaryRequestModel
		public typealias ResponseModel = UserGroupSummaryResponseModel

		public var method: HTTPMethod { .post }
		public var path: String { "userGroup/summary" }
		public var headers: [String: String] { ["Content-Type": "application/json; charset=utf-8"] }
		public var body: Body?

		public init (body: Body) {
			self.body = body
		}
	}
}
