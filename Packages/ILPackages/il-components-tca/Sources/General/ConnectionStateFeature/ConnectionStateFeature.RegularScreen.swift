import ComposableArchitecture
import ILComponents
import ILDesignResources
import ILLocalization
import ILUtils
import SwiftUI

extension ConnectionStateFeature {
	public struct RegularScreen: View {
		let store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			contentView()
				.task {
					store.send(.initialize)
				}
		}
	}
}

private extension ConnectionStateFeature.RegularScreen {
	@ViewBuilder
	func contentView () -> some View {
		if store.connectionState.isOffline {
			HStack {
				Label(.componentsConnectionStateFeatureServerIsUnavailable, systemImage: .sinNoInternet)

				Spacer()

				refreshButton()
			}
			.font(.footnote)
			.labelStyle(.titleAndIcon)
			.listRowBackground(Rectangle().fill(.yellow.tertiary))
		}
	}

	func refreshButton () -> some View {
		LoadingButton(
			isLoading: store.isRefreshing
		) {
			store.send(.refresh)
		} content: {
			Label(.generalActionRefresh, systemImage: .sinRefresh)
		} placeholder: {
			StandardLoadingView()
				.controlSize(.small)
		}
		.buttonStyle(.borderedProminent)
		.labelStyle(.iconOnly)
		.controlSize(.small)
	}
}
