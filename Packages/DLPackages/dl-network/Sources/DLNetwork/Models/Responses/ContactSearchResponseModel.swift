import DLModels

public struct ContactSearchResponseModel: Codable {
	public let searchResult: User.ContactSearch?
	
	public init (searchResult: User.ContactSearch?) {
		self.searchResult = searchResult
	}
}
