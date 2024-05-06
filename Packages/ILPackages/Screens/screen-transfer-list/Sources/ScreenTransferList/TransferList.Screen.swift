import ComposableArchitecture
import DLServices
import DLUtils
import ILUtils
import ScreenTransferEditing
import ScreenTransferGroupEditing
import SwiftUI
import TransferComponents
import UnavailablePlaceholderComponents

extension TransferList {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			contentView()
				.listStyle(.inset)
				.refreshable { await self.store.send(.refresh).finish() }
				.sheet(item: $store.scope(state: \.transferEditing, action: \.transferEditing)) { store in
					TransferEditing.Screen(store: store)
				}
				.sheet(item: $store.scope(state: \.transferGroupEditing, action: \.transferGroupEditing)) { store in
					TransferGroupEditing.Screen(store: store)
				}
				.task {
					store.send(.initialize)
				}
		}
	}
}

private extension TransferList.Screen {
	func contentView () -> some View {
		List {
			Section {
				ComposableLoadableView(
					store: store.scope(state: \.transfers, action: \.transfers),
					loadingView: loadingView,
					successfulView: successfulView,
					failedView: failedView
				)
			} header: {
				creationControlsView()
			}
		}
	}

	@ViewBuilder
	func loadingView () -> some View {
		StandardLoadingView()
			.horizontallyCentered()
	}

	func successfulView (_ store: StoreOf<Transfers.Reducer>) -> some View {
		Transfers.Screen(store: store)
			.controlSize(.small)
	}

	func failedView (_: Error) -> some View {
		StandardRetryErrorView {
			store.send(.refresh)
		}
	}
}

private extension TransferList.Screen {
	func creationControlsView () -> some View {
		HStack {
			createTransferGroupButton()
			createTransferButton()
		}
		.horizontallyCentered()
	}

	func createTransferGroupButton () -> some View {
		Button {
			store.send(.onTransferGroupCreateButtonTap)
		} label: {
			Image(systemName: "plus.rectangle.on.rectangle").font(.system(size: 20))
		}
		.buttonStyle(.bordered)
		.tint(.green)
	}

	func createTransferButton () -> some View {
		Button {
			store.send(.onTransferCreateButtonTap)
		} label: {
			Image(systemName: "plus.rectangle").font(.system(size: 20))
		}
		.buttonStyle(.bordered)
		.tint(.green)
	}
}
