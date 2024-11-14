import ComponentsTCAExpense
import ComponentsTCAUser
import ComposableArchitecture
import DLLogic
import DLServices
import ILComponents
import ILExtensions
import ILUtils
import SwiftUI

extension ExpenseEditing {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		let currencyFormatter = NumberFormatter.currency

		var totalAmountValueFormatted: String {
			currencyFormatter
				.copy(currencyCode: store.currency.code)
				.format(store.totalAmountValue.doubleExactValue) ?? "--"
		}

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			NavigationStack {
				Form {
					contentView()
				}
				.navigationTitle(.domainExpense)
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
private extension ExpenseEditing.Screen {
	@ViewBuilder
	func contentView () -> some View {
		expenseInfoEditingView()

		Section {
			creditorSelectorView()
			sumEditingView()
		}

		borrowerSelectionSection()
	}
}

// MARK: - Subviews
private extension ExpenseEditing.Screen {
	func expenseInfoEditingView () -> some View {
		ExpenseInfoEditing.Screen(
			store: store.scope(
				state: \.expenseInfoEditing,
				action: \.expenseInfoEditing
			)
		)
	}

	func sumEditingView () -> some View {
		AmountSumEditingView(
			perItemAmountValue: $store.amountValuePerItem,
			itemCount: $store.itemCount,
			totalAmountValueFormatted: totalAmountValueFormatted,
			currencyCode: store.currency.code
		)
		.textFieldStyle(.bordered)
	}

	func creditorSelectorView () -> some View {
		UserSingleSelector.Screen(store: store.scope(state: \.creditorSelector, action: \.creditorSelector))
	}
}

private extension ExpenseEditing.Screen {
	@ViewBuilder
	func borrowerSelectionSection () -> some View {
		Section {
			amountSplitView()
		} header: {
			Text(.newExpenseParticipants)
		}
	}
}

// MARK: - Amount split view
private extension ExpenseEditing.Screen {
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
		StandardErrorView(error: error) {
			RetryButton {
				store.send(.refresh)
			}
		}
	}
}

// MARK: - Toolbar
private extension ExpenseEditing.Screen {
	func cancelToolbarItem () -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			Button(.generalActionCancel) { store.send(.onCancelButtonTap) }
		}
	}

	func submitToolbarContent () -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			LoadableButton(
				label: store.mode.isCreation ? .generalActionCreate : .generalActionSave,
				loadable: store.submitRequest
			) {
				store.send(.onSubmitButtonTap)
			}
		}
	}
}
