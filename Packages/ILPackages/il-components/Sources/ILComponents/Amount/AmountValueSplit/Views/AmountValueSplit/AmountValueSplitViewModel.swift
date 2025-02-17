import DLModels
import SwiftUI

@dynamicMemberLookup
public struct AmountValueSplitViewModel {
	let interactor: AmountValueSplitInteractor

	public init (interactor: AmountValueSplitInteractor) {
		self.interactor = interactor
	}

	subscript <T> (dynamicMember keyPath: KeyPath<AmountValueSplitInteractor, T>) -> T {
		interactor[keyPath: keyPath]
	}
}

extension AmountValueSplitViewModel {
	var formattedAmount: String {
		NumberFormatter
			.currency
			.copy(currencyCode: interactor.currency.code)
			.format(interactor.usersAmountValue.double(0.01)) ?? "--"
	}

	var amountViewAppearance: AmountView.Appearance {
		interactor.usersAmountValue > interactor.totalAmountValue ? .negative : .neutral
	}

	var splitModeBinding: Binding<SplitMode> {
		.init(
			get: {
				interactor.splitMode
			},
			set: {
				interactor.onSplitModeChanged($0)
			}
		)
	}

	var partsCountBinding: Binding<Int?> {
		.init(
			get: {
				interactor.inputPartCount
			},
			set: {
				interactor.onPartCountChanged($0)
			}
		)
	}

	var isAllUsersSelectedOrLockedBinding: Binding<Bool> {
		.init(
			get: { interactor.isAllUsersSelectedOrLocked },
			set: { _ in
				withAnimation {
					interactor.onAllUsersSelectionToggled()
				}
			}
		)
	}
}
