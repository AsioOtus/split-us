import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct Register: ModellableResponseRequest {
		public typealias Body = RegistrationRequestModel
		public typealias ResponseModel = RegistrationResponseModel

		public var method: HTTPMethod { .post }
		public var path: String { "auth/register" }
		public var body: Body?

		public init (_ body: Body) {
			self.body = body
		}
	}
}

public extension Requests.Register {
	init (user: User.New) {
		self.init(.init(user: user))
	}
}
