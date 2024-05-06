import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct UpdateTransferGroupInfo: ModellableResponseRequest {
		public typealias Body = UpdateTransferGroupInfoRequestModel
		public typealias ResponseModel = SharedResponseModels.TransferUnitInfo
		
		public var method: HTTPMethod { .post }
		public var path: String { "transfers/updateTransferGroupInfo" }
		public var body: Body?
		
		public init (
			transferGroupInfo: TransferUnit.Info,
			transferGroupId: UUID
		) {
			self.body = .init(
				transferGroupId: transferGroupId,
				transferGroupInfo: transferGroupInfo
			)
		}
	}
}
