import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct Deauthenticate: ModellableResponseRequest {
		public typealias Body = DeauthenticateRequestModel
		public typealias ResponseModel = SharedResponseModels.Success
		
		public var method: HTTPMethod { .post }
		public var path: String { "auth/deauthenticate" }
		public var body: Body?
		
		public init (_ body: Body) {
			self.body = body
		}
	}
}

public extension Requests.Deauthenticate {
	init (refreshToken: String) {
		self.init(.init(refreshToken: refreshToken))
	}
}
