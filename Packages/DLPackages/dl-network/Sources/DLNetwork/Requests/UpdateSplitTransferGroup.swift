import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct UpdateTransferSplitGroup: ModellableResponseRequest {
		public typealias Body = UpdateTransferSplitGroupRequestModel
		public typealias ResponseModel = SharedResponseModels.TransferSplitGroup

		public var method: HTTPMethod { .post }
		public var path: String { "transfers/updateTransferSplitGroup" }
		public var body: Body?

		public init (body: Body) {
			self.body = body
		}
	}
}
