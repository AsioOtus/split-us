extension Never: Codable {
	public init (from decoder: Decoder) throws { fatalError() }
	public func encode (to encoder: Encoder) throws { }
}
