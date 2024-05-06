import Foundation

public struct Currency: Hashable, Codable {
	public let id: UUID
	public let code: String
	
	public init (id: UUID, code: String) {
		self.id = id
		self.code = code
	}
}

extension Currency {
	public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
		lhs.id == rhs.id
	}
}
