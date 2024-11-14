import Combine
import ComposableArchitecture
import ILDebug
import ILLocalization
import DLServices
import SwiftUI

@main
struct ScoofinApp: App {
	@Dependency(\.analyticsService) var analyticsService

	init () {
		analyticsService.configure()
		analyticsService.log(.appStarted)
	}

	var body: some Scene {
		WindowGroup {
			Root.Screen(
				store: Store(
					initialState: .splash,
					reducer: {
						Root.Reducer()
							.dependency(\.requestsConfiguration, .init(.testVm))
					}
				)
			)
			.tint(.cyan)
		}
	}
}
