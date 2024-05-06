import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct UpdateTransfer: ModellableResponseRequest {
		public typealias Body = UpdateTransferRequestModel
		public typealias ResponseModel = SharedResponseModels.Transfer

		public var method: HTTPMethod { .post }
		public var path: String { "transfers/updateTransfer" }
		public var body: Body?

		public init (
			transfer: Transfer.Update
		) {
			self.body = .init(transfer: transfer)
		}
	}
}
