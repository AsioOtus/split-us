import Foundation
import NetworkUtil

extension Requests {
	public struct User: ModellableResponseRequest {
		public typealias ResponseModel = UserResponseModel
		
		public var configuration: RequestConfiguration {
			.init()
			.setPath("users/current")
		}
		
		public init () { }
	}
}
