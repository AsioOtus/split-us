import NetworkUtil

public extension StandardResponse {
	func unfold <RM: Codable> () throws -> RM where Model == Envelope<RM> {
		try model.result.get()
	}
}
