import Foundation

public extension ExpenseGroup {
	struct New: Hashable, Codable {
		public let id: UUID
		public let info: ExpenseInfo

		public init (
			id: UUID,
			info: ExpenseInfo
		) {
			self.id = id
			self.info = info
		}
	}
}
