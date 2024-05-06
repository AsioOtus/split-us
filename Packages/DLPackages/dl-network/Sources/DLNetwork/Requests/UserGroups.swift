import Foundation
import NetworkUtil

extension Requests {
	public struct UserGroups: ModellableResponseRequest {
		public typealias ResponseModel = UserGroupsResponseModel
		
		public let path: String = "userGroup"
		
		public init () { }
	}
}
