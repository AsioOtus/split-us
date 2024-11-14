import ComponentsTCAExpense
import ComposableArchitecture
import DLModels
import ILModels
import ILModelsMappers
import ScreenSummary
import ScreenUserGroupInfo
import ScreenExpenseEditing
import ScreenExpenseGroupEditing
import SwiftUI

extension UserGroupDetails {
	public struct Screen: View {
		let expenseScreenModelMapper = ExpenseScreenModel.Mapper.default

		@Bindable var store: StoreOf<Reducer>

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			contentView()
				.task { store.send(.initialize) }
				.refreshable { await store.send(.expenseUnits(.refresh)).finish() }
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					titleToolbarItem()
					summaryToolbarItem()
					userGroupInfoToolbarItem()
				}
				.toolbar {
					expenseUnitsControlsToolbarItem()
				}
				.navigationDestination(
					item: $store.scope(state: \.summary, action: \.summary)
				) { store in
					Summary.Screen(store: store)
				}
				.navigationDestination(
					item: $store.scope(state: \.userGroupInfo, action: \.userGroupInfo)
				) { store in
					UserGroupInfo.Screen(store: store)
				}
				.sheet(
					item: $store.scope(state: \.expenseEditing, action: \.expenseEditing)
				) { store in
					ExpenseEditing.Screen(store: store)
				}
				.sheet(
					item: $store.scope(state: \.expenseGroupEditing, action: \.expenseGroupEditing)
				) { store in
					ExpenseGroupEditing.Screen(store: store)
				}
		}
	}
}

private extension UserGroupDetails.Screen {
	func contentView () -> some View {
		List {
			ExpenseUnitsFeature.Screen(
				store: store.scope(state: \.expenseUnits, action: \.expenseUnits),
				expenseView: expenseView,
				expenseGroupView: expenseGroupView
			)
			.alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
		}
		.listStyle(.inset)
	}
}

private extension UserGroupDetails.Screen {
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

private extension UserGroupDetails.Screen {
	func titleToolbarItem () -> some ToolbarContent {
		Button(store.userGroup.name) {
			store.send(.onTitleTap)
		}
		.buttonStyle(.plain)
		.asToolbarItem(placement: .principal)
	}

	func summaryToolbarItem () -> some ToolbarContent {
		Button {
			store.send(.onSummaryButtonTap)
		} label: {
			Image(systemName: "list.bullet.clipboard")
		}
		.asToolbarItem(placement: .topBarTrailing)
	}

	func userGroupInfoToolbarItem () -> some ToolbarContent {
		Button {
			store.send(.onInfoButtonTap)
		} label: {
			Image(systemName: "gear")
		}
		.asToolbarItem(placement: .topBarTrailing)
	}

	func expenseUnitsControlsToolbarItem () -> some ToolbarContent {
		ExpenseUnitButtons.controls(
			createExpense: {
				store.send(.onAddExpenseButtonTap)
			},
			createExpenseGroup: {
				store.send(.onAddExpenseGroupButtonTap)
			}
		)
		.asToolbarItem(placement: .bottomBar)
	}
}
