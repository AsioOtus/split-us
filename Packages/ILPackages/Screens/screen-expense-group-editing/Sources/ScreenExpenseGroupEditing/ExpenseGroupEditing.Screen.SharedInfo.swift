import DLModels
import ILComponents
import ILFormatters
import Multitool
import SwiftUI

extension ExpenseGroupEditing.Screen {
	public struct SharedInfoView: View {
		let currencyFormatter: NumberFormatter

		let users: Loadable<[User.Compact?]>

		@Binding var sharedInfo: ExpenseGroupEditing.State.SharedInfo

		var buttonText: LocalizedStringKey {
			sharedInfo.isEnabled
			? .expenseGroupEditingSharedInfoDisableButtonText
			: .expenseGroupEditingSharedInfoEnableButtonText
		}

		var buttonRole: ButtonRole? {
			sharedInfo.isEnabled ? .destructive : nil
		}

		var formattedRemainingAmountValue: String {
			currencyFormatter.format(sharedInfo.remainingAmountValue?.doubleExactValue ?? 0) ?? "--"
		}

		public init (
			sharedInfo: Binding<ExpenseGroupEditing.State.SharedInfo>,
			users: Loadable<[User.Compact?]>
		) {
			self._sharedInfo = sharedInfo
			self.users = users
			self.currencyFormatter = .currency.copy(currencyCode: sharedInfo.wrappedValue.currency.code)
		}

		public var body: some View {
			if sharedInfo.isEnabled {
				userSelectionView()
				amountEditingView()
				remainderView()
			}

			activationButtonView()
		}
	}
}

private extension ExpenseGroupEditing.Screen.SharedInfoView {
	func userSelectionView () -> some View {
		LoadableUserSelectionView(
			label: .domainCreditor,
			users: users,
			creditor: $sharedInfo.creditor
		)
	}

	func amountEditingView () -> some View {
		HStack {
			Text(.domainSum)
			Spacer()
			AmountEditingView(amountValue: $sharedInfo.amountValue, currency: $sharedInfo.currency)
		}
	}

	func remainderView () -> some View {
		HStack {
			Text(.expenseGroupEditingSharedInfoRemainderLabel)
			Spacer()
			AmountView(formattedRemainingAmountValue)
		}
	}

	func activationButtonView () -> some View {
		HStack {
			Spacer()

			Button(buttonText, role: buttonRole) {
				withAnimation {
					sharedInfo.isEnabled.toggle()
				}
			}

			Spacer()
		}
	}
}
