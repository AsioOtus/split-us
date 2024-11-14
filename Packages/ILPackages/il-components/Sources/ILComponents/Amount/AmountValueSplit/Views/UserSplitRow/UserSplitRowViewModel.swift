import DLModels
import ILModels
import ILFormatters
import SwiftUI

@dynamicMemberLookup
struct UserSplitRowViewModel {
	let selectionIndicatorWidth = 5.0
	
	let interactor: AmountValueSplitInteractor
	let user: SplitUser
	
	let currencyFormatter = NumberFormatter.currency
	let userScreenModelMapper = UserScreenModel.Mapper.default
	let initialsFormatter = InitialsFormatter.default

	var fillerContainerSize: CGSize?
	
	subscript <T> (dynamicMember keyPath: KeyPath<AmountValueSplitInteractor, T>) -> T {
		interactor[keyPath: keyPath]
	}
}

extension UserSplitRowViewModel {
	var userAmountExactValueBinding: Binding<Double> {
		.init(
			get: {
				user.splitValue.doubleExactValue
			},
			set: {
				interactor.onTextFieldValueChanged(value: $0.intExactValue, userId: user.id)
			}
		)
	}
	
	var userAmountPercentValueBinding: Binding<Double> {
		.init(
			get: {
				user.splitValue.doublePercentValue
			},
			set: {
				interactor.onTextFieldValueChanged(value: $0.intPercentValue, userId: user.id)
			}
		)
	}
	
	var userAmountPartsValueBinding: Binding<Int> {
		.init(
			get: {
				user.splitValue
			},
			set: {
				interactor.onTextFieldValueChanged(value: $0, userId: user.id)
			}
		)
	}

	var userScreenModel: UserScreenModel {
		userScreenModelMapper.map(user.user)
	}
}

extension UserSplitRowViewModel {
	func fillerWidth (fillerContainerSize: CGSize?) -> Double {
		guard
			let userIndex = interactor.users.firstIndex(where: { $0.id == user.id }),
			let fillerContainerSize
		else { return 0 }
		
		let fillerContainerWidth = fillerContainerSize.width - selectionIndicatorWidth
		let percent = Double(interactor.users[userIndex].amountValue) / Double(interactor.totalAmountValue)
		let fillerWidth = (fillerContainerWidth * percent).bounded(0, fillerContainerWidth)
		
		return fillerWidth
	}
	
	func preciseFillerWidth (fillerContainerSize: CGSize?) -> Double {
		guard
			let userIndex = interactor.users.firstIndex(where: { $0.id == user.id }),
			let fillerContainerSize
		else { return 0 }
		
		let fillerContainerWidth = fillerContainerSize.width - selectionIndicatorWidth
		let percent = interactor.users[userIndex].sliderValue
		let fillerWidth = (fillerContainerWidth * percent).bounded(0, fillerContainerWidth)
		
		return fillerWidth
	}
	
	var userAmountValueFormatted: String {
		currencyFormatter.format(user.amountValue.double(0.01)) ?? "--"
	}
}

extension UserSplitRowViewModel {
	func onUserSelectionToggle () {
		interactor.onUserSelectionToggle(userId: user.id)
	}
	
	func onUserLockToggle () {
		interactor.onUserLockToggle(userId: user.id)
	}
	
	func onSliderChanged (percentDifference: Double) {
		Task { @MainActor in
			interactor.onSliderChanged(percentDifference: percentDifference, userId: user.id)
		}
	}
	
	func onSliderChangingCompleted () {
		interactor.onSliderChangingCompleted(userId: user.id)
	}
	
	func onIncrement () {
		interactor.onIncrement(userId: user.id)
	}
	
	func onDecrement () {
		interactor.onDecrement(userId: user.id)
	}
}
