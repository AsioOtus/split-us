import Foundation
import NetworkUtil

extension Requests {
	public struct UserGroupSummary: ModellableResponseRequest {
		public typealias Body = UserGroupSummaryRequestModel
		public typealias ResponseModel = UserGroupSummaryResponseModel

		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.post)
			.setPath("userGroup/summary")
		}

		public var body: Body?

		public init (body: Body) {
			self.body = body
		}
	}
}
