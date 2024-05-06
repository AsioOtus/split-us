import AmountComponents
import ILFormatters
import DLModels
import SwiftUI
import UserComponents
import DLUtils

extension TransferGroupEditing.Screen {
	public struct SharedInfoView: View {
		let currencyFormatter: NumberFormatter

		let users: Loadable<[User.Compact?]>

		@Binding var sharedInfo: TransferGroupEditing.State.SharedInfo

		var buttonText: LocalizedStringKey {
			sharedInfo.isEnabled
			? .transferGroupEditingSharedInfoDisableButtonText
			: .transferGroupEditingSharedInfoEnableButtonText
		}

		var buttonRole: ButtonRole? {
			sharedInfo.isEnabled ? .destructive : nil
		}

		var formattedRemainingAmountValue: String {
			currencyFormatter.format(sharedInfo.remainingAmountValue ?? 0) ?? "--"
		}

		public init (
			sharedInfo: Binding<TransferGroupEditing.State.SharedInfo>,
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

private extension TransferGroupEditing.Screen.SharedInfoView {
	func userSelectionView () -> some View {
		LoadableUserSelectionView(
			label: .domainCreditor,
			users: users,
			creditor: $sharedInfo.creditor
		)
	}

	func amountEditingView () -> some View {
		EmptyView()
//		SumEditingView(amountValue: $sharedInfo.amountValue, currency: sharedInfo.currency)
	}

	func remainderView () -> some View {
		HStack {
			Text(.transferGroupEditingSharedInfoRemainderLabel)
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
