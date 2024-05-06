import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct DeleteTransferGroup: ModellableResponseRequest {
		public typealias Body = SharedRequestModels.DeleteTransferUnit
		public typealias ResponseModel = SharedResponseModels.Success

		public var method: HTTPMethod { .delete }
		public var path: String { "transfers/deleteTransferGroup" }
		public var body: Body?

		public init (_ body: Body) {
			self.body = body
		}
	}
}

public extension Requests.DeleteTransferGroup {
	init (transferGroupId: UUID) {
		self.init(.init(transferUnitId: transferGroupId))
	}
}
