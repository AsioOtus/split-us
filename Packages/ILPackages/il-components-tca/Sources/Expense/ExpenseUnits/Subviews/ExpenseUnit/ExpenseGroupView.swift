import DLLogic
import ILComponents
import ILFormatters
import ILModels
import SwiftUI
import SwiftUIExtensions

public struct ExpenseGroupView: View {
	let expenseScreenModel: ExpenseScreenModel

	public init (
		expenseScreenModel: ExpenseScreenModel
	) {
		self.expenseScreenModel = expenseScreenModel
	}

	public var body: some View {
		ExpenseUnitLayout(
			contentView: contentView,
			iconView: iconView,
			titleView: titleView,
			accessoryView: accessoryView
		)
	}

	func contentView () -> some View {
		EmptyView()
	}

	func iconView () -> some View {
		Image(systemName: .sinDomainExpenseGroup)
			.font(.title3)
			.fontWeight(.light)
			.foregroundStyle(.tint)
			.symbolVariant(.fill)
	}

	func titleView () -> some View {
		ExpenseUnitTitleView(expenseInfo: expenseScreenModel.expenseInfo)
	}

	@ViewBuilder
	func accessoryView () -> some View {
		if expenseScreenModel.offlineStatus.isOfflineCreated {
			OfflineCreatedIconView()
		}
	}
}

#Preview {
	ExpenseGroupView(
		expenseScreenModel: .exampleA
	)
}
