import Foundation
import NetworkUtil

extension Requests {
	public struct User: ModellableResponseRequest {
		public typealias ResponseModel = UserResponseModel
		
		public let path: String = "users/current"
		
		public init () { }
	}
}
