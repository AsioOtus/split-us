import Dependencies

public protocol PAnalyticsService {
	func configure ()
	func log (_ event: AnalyticsEvent)
}

public enum AnalyticsServiceDependencyKey: DependencyKey {
	public static var liveValue: any PAnalyticsService {
		AnalyticsService()
	}
}

public extension DependencyValues {
	var analyticsService: any PAnalyticsService {
		get { self[AnalyticsServiceDependencyKey.self] }
		set { self[AnalyticsServiceDependencyKey.self] = newValue }
	}
}
