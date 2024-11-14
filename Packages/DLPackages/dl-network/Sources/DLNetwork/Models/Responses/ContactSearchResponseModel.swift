import DLModels

public struct ContactSearchResponseModel: Codable {
	public let searchResult: User.Contact?
	
	public init (searchResult: User.Contact?) {
		self.searchResult = searchResult
	}
}
