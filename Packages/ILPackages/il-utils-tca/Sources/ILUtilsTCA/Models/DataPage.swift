import IdentifiedCollections

public struct DataPage <Model>: Identifiable where Model: Identifiable {
	public var pageNumber = 0
	public var models: IdentifiedArrayOf<Model>
	public var status: Status

	public var id: Int { pageNumber }

	public init (
		pageNumber: Int = 0,
		models: IdentifiedArrayOf<Model>,
		status: Status
	) {
		self.pageNumber = pageNumber
		self.models = models
		self.status = status
	}
}

extension DataPage: Equatable where Model: Equatable { }
extension DataPage: Hashable where Model: Hashable { }

extension DataPage {
	public enum Status {
		case local
		case remote
	}
}
