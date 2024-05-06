import Foundation

extension TransferUnit {
	public struct Info: Hashable, Codable {
		public let name: String?
		public let note: String?
		public let date: Date?
		
		public init (
			name: String? = nil,
			note: String? = nil,
			date: Date? = nil
		) {
			self.name = name
			self.note = note
			self.date = date
		}
	}
}
