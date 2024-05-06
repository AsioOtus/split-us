import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct DeleteTransfer: ModellableResponseRequest {
		public typealias Body = SharedRequestModels.DeleteTransferUnit
		public typealias ResponseModel = SharedResponseModels.Success

		public var method: HTTPMethod { .delete }
		public var path: String { "transfers/deleteTransfer" }
		public var body: Body?

		public init (_ body: Body) {
			self.body = body
		}
	}
}

public extension Requests.DeleteTransfer {
	init (transferId: UUID) {
		self.init(.init(transferUnitId: transferId))
	}
}
