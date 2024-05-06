import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct CreateTransferGroup: ModellableResponseRequest {
		public typealias Body = CreateTransferGroupRequestModel
		public typealias ResponseModel = SharedResponseModels.TransferGroup
		
		public var method: HTTPMethod { .post }
		public var path: String { "transfers/createTransferGroup" }
		public var body: Body?
		
		public init (
			transferGroupContainer: TransferGroup.New.Container,
			superTransferGroupId: UUID?,
			userGroupId: UUID
		) {
			self.body = .init(
				transferGroupContainer: transferGroupContainer,
				superTransferGroupId: superTransferGroupId,
				userGroupId: userGroupId
			)
		}
	}
}
