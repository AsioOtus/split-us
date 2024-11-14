import Foundation
import NetworkUtil
import DLModels

extension Requests {
	public struct HealthPing: Request {
		public var configuration: RequestConfiguration {
			.init()
			.setMethod(.get)
			.setPath("health/ping")
		}

		public init () { }
	}
}
