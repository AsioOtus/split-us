import DLLogic
import ILComponents
import ILFormatters
import ILModels
import SwiftUI
import SwiftUIExtensions

public struct ExpenseView: View {
	@Namespace private var participantsAnimation

	@SwiftUI.State private var isExpanded = false

	let expenseScreenModel: ExpenseScreenModel

	var creditorParticipant: ExpenseParticipantScreenModel? {
		if
			let creditor = expenseScreenModel.creditors.first,
			let amount = expenseScreenModel.amounts.first {
			.init(
				user: creditor,
				amount: amount
			)
		} else {
			nil
		}
	}

	public init (
		expenseScreenModel: ExpenseScreenModel
	) {
		self.expenseScreenModel = expenseScreenModel
	}

	public var body: some View {
		contentView()
			.avatarAnimationNamespace(participantsAnimation)
	}

	@ViewBuilder
	private func contentView () -> some View {
		ExpenseUnitLayout(
			contentView: cView,
			iconView: iconView,
			titleView: titleView,
			accessoryView: accessoryView
		)
	}

	func cView () -> some View {
		VStack(spacing: 0) {
			infoView()

			ExpandableView(isExpanded: $isExpanded) {
				detailsView()
					.padding(.top, 2)
			}
		}
	}

	func iconView () -> some View {
		Image(systemName: .sinDomainExpense)
			.font(.title3)
			.fontWeight(.light)
			.foregroundStyle(.tint)
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

private extension ExpenseView {
	func infoView () -> some View {
		VStack(alignment: .leading, spacing: 0) {
			if !isExpanded {
				HStack(alignment: .center) {
					amountsView()
					Spacer()
					usersRelationshipView()
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
		.contentShape(.rect)
		.onTapGesture {
			withAnimation {
				isExpanded.toggle()
			}
		}
	}

	func amountsView () -> some View{
		AmountStack(amounts: expenseScreenModel.amounts) { amount in
			AmountView(amount)
				.controlSize(.small)
				.matchedGeometryEffect(
					id: ExpenseParticipantsView.creditorAmountAnimationId,
					in: participantsAnimation
				)
		}
	}

	@ViewBuilder
	func usersRelationshipView () -> some View {
		if !expenseScreenModel.creditors.isEmpty || !expenseScreenModel.borrowers.isEmpty {
			UsersRelationshipView(
				creditors: expenseScreenModel.creditors,
				borrowers: expenseScreenModel.borrowers.map(\.user)
			)
			.avatarSize(.small)
		}
	}

	func detailsView () -> some View {
		ExpenseInfoDetailsView(
			expenseInfo: expenseScreenModel,
			participantsAnimation: participantsAnimation
		)
	}
}

#Preview {
	ExpenseView(
		expenseScreenModel: .exampleA
	)
}
