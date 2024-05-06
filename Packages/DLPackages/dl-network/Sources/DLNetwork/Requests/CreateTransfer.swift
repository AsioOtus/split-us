import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct CreateTransfer: ModellableResponseRequest {
		public typealias Body = CreateTransferRequestModel
		public typealias ResponseModel = SharedResponseModels.Transfer
		
		public var method: HTTPMethod { .post }
		public var path: String { "transfers/createTransfer" }
		public var body: Body?
		
		public init (
			transfer: Transfer.New,
			superTransferGroupId: UUID?,
			userGroupId: UUID
		) {
			self.body = .init(
				transfer: transfer,
				superTransferGroupId: superTransferGroupId,
				userGroupId: userGroupId
			)
		}
	}
}
