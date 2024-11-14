@dynamicMemberLookup
public struct OfflineTriggerError: Error {
	public let error: Error

	public init (error: Error) {
		self.error = error
	}

	public subscript <Value> (dynamicMember keyPath: KeyPath<Error, Value>) -> Value {
		error[keyPath: keyPath]
	}
}
