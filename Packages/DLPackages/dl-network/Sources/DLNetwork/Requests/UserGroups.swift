import Foundation
import NetworkUtil

extension Requests {
	public struct UserGroups: ModellableResponseRequest {
		public typealias ResponseModel = UserGroupsResponseModel
		
		public var configuration: RequestConfiguration {
			.init()
			.setPath("userGroup")
		}
		
		public init () { }
	}
}
