import Combine
import SwiftUI

public struct Debug {
	public static var `default` = Self(action: { })
	
	public var subscriptions = Set<AnyCancellable>()
	
	public static func action (_ action: () -> Void) {
		action()
	}
	
	public static func value <Value> (_ value: Value) -> Value {
		value
	}
	
	public static func value <Value> (_ value: () -> Value) -> Value {
		value()
	}
	
	public static func text (_ text: String) -> Text {
		.init(text)
	}
	
	@discardableResult
	public init (action: () throws -> Void = { }) rethrows {
		try action()
	}
	
	@discardableResult
	public init (action: () async -> Void = { }) async {
		await action()
	}
	
	@discardableResult
	public init (action: () async throws -> Void = { }) async rethrows {
		try await action()
	}
}
