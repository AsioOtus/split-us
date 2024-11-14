import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct CreateUserGroup: ModellableResponseRequest {
		public typealias Body = CreateUserGroupRequestModel
		public typealias ResponseModel = SharedResponseModels.Success
		
		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.post)
			.setPath("userGroup/create")
		}
		
		public var body: Body?
		
		public init (body: Body) {
			self.body = body
		}
	}
}
