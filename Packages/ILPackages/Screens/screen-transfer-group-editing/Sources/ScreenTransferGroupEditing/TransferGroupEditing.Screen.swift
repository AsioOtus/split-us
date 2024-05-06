import ComposableArchitecture
import DLServices
import DLUtils
import ILUtils
import ScreenTransferEditing
import SwiftUI
import TransferComponents

extension TransferGroupEditing {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			NavigationStack {
				Form {
					transferInfoEditingView()

					if store.isCreation {
						sharedInfoView()
					}

					Section {
						creationControlsView()
						transfersView()
					} header: {
						Text(.transfersTitle)
					}
				}
				.sheet(item: $store.scope(state: \.transferEditing, action: \.transferEditing)) {
					TransferEditing.Screen(store: $0)
				}
				.sheet(item: $store.scope(state: \.transferGroupEditing, action: \.transferGroupEditing)) {
					TransferGroupEditing.Screen(store: $0)
				}
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button(.generalActionCancel) { store.send(.onCancelButtonTap) }
					}

					ToolbarItem(placement: .navigationBarTrailing) {
						Button(store.isCreation ? .generalActionCreate : .generalActionSave) { store.send(.onSubmitButtonTap) }
					}
				}
				.interactiveDismissDisabled()
				.navigationTitle(store.name ?? "")
				.task {
					store.send(.initialize)
				}
			}
		}
	}
}

private extension TransferGroupEditing.Screen {
	func transferInfoEditingView () -> some View {
		TransferInfoEditing.Screen(
			name: $store.name,
			note: $store.note,
			date: $store.date
		)
	}

	func sharedInfoView () -> some View {
		Section {
			TransferGroupEditing.Screen.SharedInfoView(
				sharedInfo: $store.sharedInfo,
				users: store.sharedCreditorSelectionUsers
			)
		} header: {
			Text(.transferGroupEditingSharedInfoTitle)
		}
	}

	func transfersView () -> some View {
		ComposableLoadableView(
			store: store.scope(state: \.transfers, action: \.transfers),
			successfulView: { store in
				Transfers.Screen(store: store)
			}
		)
	}

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

#Preview {
	TransferGroupEditing.Screen(
		store: .init(
			initialState: .init(
				initialTransferGroupContainer: nil,
				isLocal: true,
				superTransferGroupId: nil,
				userGroup: .init(
					id: .init(),
					name: ""
				),
				sharedInfo: .init(currency: .eur)
			),
			reducer: {
				TransferGroupEditing.Reducer()
			}
		)
	)
}
