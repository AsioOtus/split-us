import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct Reauthenticate: ModellableResponseRequest {
		public typealias Body = ReauthenticateRequestModel
		public typealias ResponseModel = ReauthenticateResponseModel
		
		public var method: HTTPMethod { .post }
		public var path: String { "auth/reauthenticate" }
		public var body: Body?
		
		public init (_ body: Body) {
			self.body = body
		}
	}
}

public extension Requests.Reauthenticate {
	init (userId: UUID, refreshToken: String) {
		self.init(.init(userId: userId, refreshToken: refreshToken))
	}
}
