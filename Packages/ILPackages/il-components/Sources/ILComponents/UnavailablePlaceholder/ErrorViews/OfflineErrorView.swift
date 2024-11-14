import ILDesignResources
import SwiftUI

public struct OfflineErrorView <ActionView: View>: View {
	let actionView: ActionView

	public init (@ViewBuilder actionView: () -> ActionView) {
		self.actionView = actionView()
	}

	public var body: some View {
		ContentUnavailableView {
			Label(.domainErrorNoInternet, systemImage: .sinNoInternet)
		} description: {
			Text(.domainErrorCheckInternetConnection)
		} actions: {
			actionView
		}
	}
}
