import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct CreateTransferSplitGroup: ModellableResponseRequest {
		public typealias Body = CreateTransferSplitGroupRequestModel
		public typealias ResponseModel = SharedResponseModels.TransferSplitGroup

		public var method: HTTPMethod { .post }
		public var path: String { "transfers/createTransferSplitGroup" }
		public var body: Body?

		public init (body: Body) {
			self.body = body
		}
	}
}
