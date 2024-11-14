import ComponentsTCAExpense
import ComponentsTCAGeneral
import ComponentsTCAUser
import ComposableArchitecture
import DLModels
import DLServices
import ILComponents
import ILLocalization
import ILModels
import ILModelsMappers
import ILUtils
import ILUtilsTCA
import ScreenExpenseEditing
import SwiftUI

extension ExpenseGroupEditing {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		let expenseScreenModelMapper = ExpenseScreenModel.Mapper.default

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		var actionButtonTitle: LocalizedStringKey {
			switch store.mode {
			case .review: .generalActionEdit
			case .creation: .generalActionCreate
			case .updating: .generalActionSave
			}
		}

		var cancelButtonTitle: LocalizedStringKey {
			switch store.mode {
			case .review, .creation: .generalActionClose
			case .updating: .generalActionCancel
			}
		}

		var errorToastMessageKey: LocalizedStringKey {
			switch store.editingError {
			case .creationError: .expenseGroupEditingToastErrorCreationError
			case .updatingError: .expenseGroupEditingToastErrorUpdatingError
			case .offlineUpdateAttempt: .expenseGroupEditingToastErrorOfflineUpdateAttempt
			default: .generalErrorSomethingWentWrong
			}
		}

		var isInteractiveDismissDisabled: Bool {
			store.mode != .review && store.isChanged
		}

		var isDisabled: Bool {
			store.mode == .review ||
			store.mode == .updating && store.submitRequest.isLoading
		}

		var isActionButtonDisabled: Bool {
			store.connectionStateFeature.connectionState.isOffline &&
			store.expenseGroup?.offlineStatus.isOfflineCreated == false
		}

		var isLoading: Bool {
			store.expenseGroupRequest.isLoading && store.connectionStateFeature.connectionState.isOffline
		}

		var navigationTitle: LocalizedStringKey {
			switch store.mode {
			case .review: .domainShortExpenseGroup
			case .creation: .domainShortExpenseGroup
			case .updating: .generalEditing
			}
		}

		public var body: some View {
			NavigationStack {
				contentView()
					.sheet(item: $store.scope(state: \.expenseEditing, action: \.expenseEditing)) {
						ExpenseEditing.Screen(store: $0)
					}
					.sheet(item: $store.scope(state: \.expenseGroupEditing, action: \.expenseGroupEditing)) {
						ExpenseGroupEditing.Screen(store: $0)
					}
					.toolbar {
						cancelButton().asToolbarItem(placement: .topBarLeading)
						loadingIndicatorView().asToolbarItem(placement: .topBarTrailing)
						submitButton().asToolbarItem(placement: .topBarTrailing)
						titleView().asToolbarItem(placement: .principal)
						dismissKeyboardToolbarItemGroup()
					}
					.navigationBarTitleDisplayMode(.inline)
			}
			.task {
				store.send(.initialize)
				store.send(.connectionStateFeature(.initialize))
			}
			.interactiveDismissDisabled(isInteractiveDismissDisabled)
			.presentationDetents([.large, .fraction(0.1)], selection: .constant(.large))
			.presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.1)))
			.toast(isPresenting: $store.isErrorToastVisible, offsetY: 20) {
				Toasts.error(message: errorToastMessageKey)
			}
			.toast(isPresenting: $store.isLocalCreationInfoToastVisible, offsetY: 20) {
				Toasts.regular(message: .expenseGroupEditingToastInfoOfflineCreated, systemImage: "externaldrive.fill")
			}
		}
	}
}

private extension ExpenseGroupEditing.Screen {
	func contentView () -> some View {
		List {
			connectionStateFeatureView()

			expenseInfoEditingView()

//			LabeledContent {
//				UserSingleSelector.Screen(store: store.scope(state: \.userSelector, action: \.userSelector))
//			} label: {
//				Text(.domainCreditor)
//			}

			expenseUnitsSectionView()

			//			if store.isCreation {
			//				sharedInfoView()
			//			}
		}
	}
}

private extension ExpenseGroupEditing.Screen {
	func connectionStateFeatureView () -> some View {
		ConnectionStateFeature.RegularScreen(
			store: store.scope(
				state: \.connectionStateFeature,
				action: \.connectionStateFeature
			)
		)
	}

	func expenseInfoEditingView () -> some View {
		ExpenseInfoEditing.Screen(
			store: store.scope(
				state: \.expenseInfoEditing,
				action: \.expenseInfoEditing
			)
		)
		.disabled(isDisabled)
	}

	//	func sharedInfoView () -> some View {
	//		Section {
	//			ExpenseGroupEditing.Screen.SharedInfoView(
	//				sharedInfo: $store.sharedInfo,
	//				users: store.sharedCreditorSelectionUsers
	//			)
	//		} header: {
	//			Text(.expenseGroupEditingSharedInfoTitle)
	//		}
	//	}

	func creationControlsView () -> some View {
		ExpenseUnitButtons.controls(
			createExpense: {
				store.send(.onAddExpenseButtonTap)
			},
			createExpenseGroup: {
				store.send(.onAddExpenseGroupButtonTap)
			}
		)
		.frame(maxWidth: .infinity, alignment: .center)
		.labelStyle(.iconOnly)
	}

	@ViewBuilder
	func expenseUnitsSectionView () -> some View {
		if !store.mode.isCreation {
			Section {
				creationControlsView()
				expenseUnitsView()
			} header: {
				Text(.expensesTitle)
			}
			.disabled(!store.mode.isReview)
		}
	}

	@ViewBuilder
	func expenseUnitsView () -> some View {
		ExpenseUnitsFeature.Screen(
			store: store.scope(state: \.expenseUnitsFeature, action: \.expenseUnitsFeature),
			expenseView: expenseView,
			expenseGroupView: expenseGroupView
		)
	}
}

private extension ExpenseGroupEditing.Screen {
	func expenseView (_ expense: Expense, _ superExpenseGroupId: UUID?) -> some View {
		VStack(alignment: .leading) {
			//			debugIdView(expense.id)

			ExpenseView(expenseScreenModel: expenseScreenModelMapper.map(expense))
		}
	}

	func expenseGroupView (_ expenseGroup: ExpenseGroup, _ superExpenseGroupId: UUID?) -> some View {
		VStack(alignment: .leading) {
			//			debugIdView(expenseGroup.id)

			ExpenseGroupView(expenseScreenModel: expenseScreenModelMapper.map(expenseGroup))
		}
	}

	func debugIdView (_ id: UUID) -> some View {
		Text(id.uuidString)
			.font(.caption2)
			.foregroundStyle(.tertiary)
	}
}

private extension ExpenseGroupEditing.Screen {
	func cancelButton () -> some View {
		Button(cancelButtonTitle) { store.send(.onCancelButtonTap) }	}

	func submitButton () -> some View {
		LoadingButton(
			isLoading: store.submitRequest.isLoading
		) {
			store.send(.onActionButtonTap)
		} content: {
			Text(actionButtonTitle)
		}
		.disabled(isActionButtonDisabled)
	}

	@ViewBuilder
	func loadingIndicatorView () -> some View {
		if isLoading {
			StandardLoadingView().controlSize(.small)
		}
	}

	func titleView () -> some View {
		Menu {
			Label(.expenseGroupEditingOfflineCreatedDescription, systemImage: .sinOfflineCreated)
		} label: {
			HStack(spacing: 4) {
				if store.expenseGroup?.offlineStatus.isOfflineCreated == true {
					Text(Image(systemName: .sinOfflineCreated))
						.symbolVariant(.fill)
						.foregroundStyle(.tint)
						.imageScale(.small)
				}

				Text(navigationTitle)
					.fontWeight(.medium)
			}
			.foregroundStyle(.foreground)
		}
		.allowsHitTesting(store.expenseGroup?.offlineStatus.isOfflineCreated == true)
	}
}
