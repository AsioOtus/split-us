import AmountComponents
import ButtonComponents
import ComposableArchitecture
import DLLogic
import DLServices
import DLUtils
import ILExtensions
import ILUtils
import KeyboardComponents
import SwiftUI
import TextFieldComponents
import TransferComponents
import UnavailablePlaceholderComponents
import UserComponents

extension TransferEditing {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		let currencyFormatter = NumberFormatter.currency

		var totalAmountValueFormatted: String {
			currencyFormatter.format(store.totalAmountValue.doubleExactValue) ?? "--"
		}

		var remainingAmountValueFormatted: String {
			store.remainingAmountValue.flatMap { currencyFormatter.format($0.doubleExactValue) } ?? "--"
		}

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			NavigationStack {
				Form {
					contentView()
				}
				.navigationTitle(store.name ?? "")
				.toolbar {
					cancelToolbarItem()
					submitToolbarContent()
					dismissKeyboardToolbarItemGroup()
				}
				.interactiveDismissDisabled()
				.onAppear {
					store.send(.initialize)
				}
			}
		}
	}
}

// MARK: - Content view
private extension TransferEditing.Screen {
	@ViewBuilder
	func contentView () -> some View {
		transferInfoEditingView()

		Section {
			creditorSelectionView()

			if let remainingAmountValue = store.remainingAmountValue {
				remainingAmountValueView(remainingAmountValue)
			}

			sumEditingView()
		}

		borrowerSelectionSection()
	}
}

// MARK: - Subviews
private extension TransferEditing.Screen {
	func transferInfoEditingView () -> some View {
		TransferInfoEditing.Screen(
			name: $store.name,
			note: $store.note,
			date: $store.date
		)
	}

	func sumEditingView () -> some View {
		AmountSumEditingView(
			perItemAmountValue: $store.perItemAmountValueInput,
			itemCount: $store.itemCount,
			totalAmountValueFormatted: totalAmountValueFormatted,
			currencyCode: store.currency.code
		)
		.textFieldStyle(.bordered)
	}

	func remainingAmountValueView (_ remainingAmountValue: Int) -> some View {
		HStack {
			Text(.transferGroupEditingSharedInfoRemainderLabel)
			Spacer()
			AmountView(remainingAmountValueFormatted)
		}
	}

	func creditorSelectionView () -> some View {
		LoadableUserSelectionView(
			label: .domainCreditor,
			users: store.creditorSelectionUsers,
			creditor: $store.creditor
		)
	}
}

private extension TransferEditing.Screen {
	@ViewBuilder
	func borrowerSelectionSection () -> some View {
		Section {
			amountSplitView()
		} header: {
			Text(.newTransferParticipants)
		}
	}
}

// MARK: - Amount split view
private extension TransferEditing.Screen {
	func amountSplitView () -> some View {
		LoadableView(
			value: store.users,
			loadingView: loadingView,
			successfulView: { _ in
				successfulAmountSplitView()
			},
			failedView: failedView
		)
	}

	func loadingView () -> some View {
		StandardLoadingView()
			.horizontallyCentered()
	}

	@ViewBuilder
	func successfulAmountSplitView () -> some View {
		if let interactor = store.amountValueSplitInteractor {
			AmountValueSplitView(vm: .init(interactor: interactor))
				.environmentObject(interactor)
		}
	}

	func failedView (_ error: Error) -> some View {
		StandardRetryErrorView {
			store.send(.refresh)
		}
	}
}

// MARK: - Toolbar
private extension TransferEditing.Screen {
	func cancelToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			Button(.generalActionCancel) { store.send(.onCancelButtonTap) }
		}
	}

	func submitToolbarContent () -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			LoadableButton(
				label: store.isCreation ? .generalActionCreate : .generalActionSave,
				loadable: store.submitRequest
			) {
				store.send(.onSubmitButtonTap)
			}
		}
	}
}
