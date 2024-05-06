import DLModels
import DLLogic
import SwiftUI

public final class AmountValueSplitInteractor: ObservableObject {
	let allowedSplitModes: [SplitMode] = [.exact, .percent, .parts]

	@Published public var users: [SplitUser]
	@Published var totalAmountValue: Int = 10
	@Published var splitMode: SplitMode = .exact
	@Published var inputPartCount: Int?

	public init (
		users: [SplitUser],
		totalAmountValue: Int,
		splitMode: SplitMode = .exact,
		inputPartCount: Int = 1
	) {
		self.users = users
		self.totalAmountValue = totalAmountValue
		self.splitMode = splitMode
		self.inputPartCount = inputPartCount
	}
}

extension AmountValueSplitInteractor: Equatable {
	public static func == (lhs: AmountValueSplitInteractor, rhs: AmountValueSplitInteractor) -> Bool {
		lhs.allowedSplitModes == rhs.allowedSplitModes &&
		lhs.totalAmountValue == rhs.totalAmountValue &&
		lhs.splitMode == rhs.splitMode &&
		lhs.inputPartCount == rhs.inputPartCount &&
		lhs.users == rhs.users
	}
}

private extension AmountValueSplitInteractor {
	var percentDecimalPrecision: Int { 10 }
	var maxPercentValue: Int { 100 * percentDecimalPrecision }

	var sliderChangeStep: Int {
		switch totalAmountValue {
		case 0..<10_00: 1
		case 10_00..<50_00: 10
		case 50_00..<150_00: 50
		case 150_00..<750_00: 100
		case 750_00...: 500
		default: 1
		}
	}

	var stepperExactChangeStep: Int {
		switch totalAmountValue {
		case 0..<5_00: 1
		case 5_00..<50_00: 1
		case 50_00..<150_00: 10
		case 150_00..<750_00: 50
		case 750_00...: 100
		default: 1
		}
	}

	var stepperPercentChangeStep: Int {
		switch totalAmountValue {
		case 0..<2_00: 10
		case 2_00..<5_00: 5
		case 5_00...: 1
		default: 1
		}
	}

	var stepperPartsChangeStep: Int {
		1
	}
}

extension AmountValueSplitInteractor {
	var partCount: Int {
		inputPartCount ?? (usersSplitValue != 0 ? usersSplitValue : 1)
	}
}

extension AmountValueSplitInteractor {
	var selectedUsers: [SplitUser] {
		users.filter { $0.selectionState.isSelected }
	}

	var lockedUsers: [SplitUser] {
		users.filter { $0.selectionState.isLocked }
	}

	var isAllUsersSelectedOrLocked: Bool {
		users.allSatisfy { $0.selectionState.isSelectedOrLocked }
	}

	var isAllUsersUnselected: Bool {
		users.allSatisfy { $0.selectionState.isUnselected }
	}
}

extension AmountValueSplitInteractor {
	var usersAmountValue: Int {
		users.map(\.amountValue).reduce(0, +)
	}

	var selectedAmountValue: Int {
		selectedUsers.map(\.amountValue).reduce(0, +)
	}

	var lockedAmountValue: Int {
		lockedUsers.map(\.amountValue).reduce(0, +)
	}

	var unlockedAmountValue: Int {
		max(totalAmountValue - lockedAmountValue, 0)
	}

	var equallyDividedUnlockedAmountValue: Int {
		unlockedAmountValue / selectedUsers.count
	}
}

extension AmountValueSplitInteractor {
	var usersSplitValue: Int {
		users.map(\.splitValue).reduce(0, +)
	}

	var selectedSplitValue: Int {
		selectedUsers.map(\.splitValue).reduce(0, +)
	}

	var lockedSplitValue: Int {
		lockedUsers.map(\.splitValue).reduce(0, +)
	}

	var equallyDividedSelectedSplitValue: Int {
		selectedSplitValue / selectedUsers.count
	}
}

public extension AmountValueSplitInteractor {
	func onTotalAmountValueChanged (_ value: Int) {
		self.totalAmountValue = value

		refreshSelectedSplitValues()
		splitSelectedAmount()
	}

	func onSplitModeChanged (_ splitMode: SplitMode) {
		self.splitMode = splitMode

		refreshSelectedSplitValues()
		refreshLockedSplitValues()

		if
			splitMode == .parts,
			!isAllUsersUnselected,
			usersAmountValue != totalAmountValue,
			inputPartCount == nil
		{
			inputPartCount = totalAmountValue
		}
	}

	func onPartCountChanged (_ partCount: Int?) {
		self.inputPartCount = partCount

		if splitMode == .parts {
			users.indices.forEach {
				updateUserSplitValue(splitValue: users[$0].splitValue, index: $0)
			}

			splitPartsRemainder()
		}
	}

	func onAllUsersSelectionToggled () {
		if isAllUsersSelectedOrLocked {
			users.indices.forEach {
				users[$0].selectionState = .unselected
				users[$0].reset()
			}
		} else {
			users.indices.forEach {
				users[$0].selectionState.safeSelect()
			}
		}

		if splitMode == .parts {
			if inputPartCount != nil {
				users.iterate(where: { users[$0].selectionState == .selected }) {
					updateUserPartsSplitAmountValue(splitValue: partCount / users.count, index: $0)
				}
			} else {
				users.iterate(where: { users[$0].selectionState == .selected }) {
					updateUserPartsSplitAmountValue(splitValue: 1, index: $0)
				}
			}

			splitPartsRemainder()
		}

		splitSelectedAmount()
	}

	func onUserSelectionToggle (userId: UUID) {
		guard let i = users.firstIndex(where: { $0.id == userId }) else { return }
		users[i].selectionState.safeToggleSelection()

		if users[i].selectionState.isUnselected {
			users[i].reset()
		}

		if splitMode == .parts && users[i].selectionState == .selected {
			updateUserPartsSplitAmountValue(splitValue: 1, index: i)
		}

		splitSelectedAmount()
	}

	func onUserLockToggle (userId: UUID) {
		guard let i = users.firstIndex(where: { $0.id == userId }) else { return }
		users[i].selectionState.forcedUnselectedLockToggle()

		splitSelectedAmount()
	}

	func onTextFieldValueChanged (value: Int, userId: UUID) {
		guard
			let i = users.firstIndex(where: { $0.id == userId }),
			value != users[i].splitValue
		else { return }

		let amountValue = amountValue(value)

		users[i].selectionState = .locked
		users[i].amountValue = amountValue
		users[i].splitValue = value
		users[i].sliderValue = sliderValue(amountValue)

		splitSelectedAmount()
	}

	func onSliderChanged (percentDifference: Double, userId: UUID) {
		switch splitMode {
		case .exact: fallthrough
		case .percent where totalAmountValue <= 100:
			updateUserExactAmount(percentDifference: percentDifference, userId: userId)
		case .percent:
			updateUserExactAmount(percentDifference: percentDifference, userId: userId)
		case .parts:
			updateUserPartsAmount(percentDifference: percentDifference, userId: userId)
		}
	}

	func onSliderChangingCompleted (userId: UUID) {
		guard let i = users.firstIndex(where: { $0.id == userId }) else { return }

		users[i].sliderValue = sliderValue(users[i].amountValue)
	}

	func onIncrement (userId: UUID) {
		switch splitMode {
		case .exact:
			updateUserExactAmount(absoluteDifference: stepperExactChangeStep, userId: userId)
		case .percent where totalAmountValue > 100:
			updateUserPercentAmount(absoluteDifference: stepperPercentChangeStep, userId: userId)
		case .percent:
			updateUserExactAmount(absoluteDifference: stepperExactChangeStep, userId: userId)
		case .parts:
			updateUserPartsAmount(absoluteDifference: stepperPartsChangeStep, userId: userId)
		}
	}

	func onDecrement (userId: UUID) {
		switch splitMode {
		case .exact:
			updateUserExactAmount(absoluteDifference: -stepperExactChangeStep, userId: userId)
		case .percent where totalAmountValue > 100:
			updateUserPercentAmount(absoluteDifference: -stepperPercentChangeStep, userId: userId)
		case .percent:
			updateUserExactAmount(absoluteDifference: -stepperExactChangeStep, userId: userId)
		case .parts:
			updateUserPartsAmount(absoluteDifference: -stepperPartsChangeStep, userId: userId)
		}
	}
}

private extension AmountValueSplitInteractor {
	func updateUserExactAmount (percentDifference: Double, userId: UUID) {
		guard let i = users.firstIndex(where: { $0.id == userId }) else { return }

		let newSliderValue = (users[i].sliderValue + percentDifference)
		let newAmountValue = (totalAmountValue.doubleExactValue * newSliderValue.bounded(0, 1)).granulate(step: sliderChangeStep.doubleExactValue).intExactValue

		if newSliderValue >= 0 {
			users[i].selectionState = .locked
		}
		users[i].amountValue = newAmountValue
		users[i].splitValue = splitValue(newAmountValue)
		users[i].sliderValue = newSliderValue.bounded(-0.1, 1)

		sliderUnselect(userIndex: i)
		splitSelectedAmount()
	}

	func updateUserPercentAmount (percentDifference: Double, userId: UUID) {
		guard let i = users.firstIndex(where: { $0.id == userId }) else { return }

		let newSliderValue = (users[i].sliderValue + percentDifference)
		let intNewSplitValue = (totalAmountValue.doubleExactValue * newSliderValue.bounded(0, 1)).granulate(step: 10.doublePercentValue).intPercentValue

		if newSliderValue >= 0 {
			users[i].selectionState = .locked
		}
		users[i].amountValue = amountValue(intNewSplitValue)
		users[i].splitValue = intNewSplitValue
		users[i].sliderValue = newSliderValue.bounded(-0.1, 1)

		sliderUnselect(userIndex: i)
		splitSelectedAmount()
	}

	func updateUserPartsAmount (percentDifference: Double, userId: UUID) {
		guard inputPartCount != nil else { return }
		guard let i = users.firstIndex(where: { $0.id == userId }) else { return }

		let newSliderValue = (users[i].sliderValue + percentDifference)
		let newSplitValue = newSliderValue.bounded(0, 1) * partCount.double()
		let granulationStep = 1.0 / partCount.double()
		let intNewSplitValue = newSplitValue.granulate(step: granulationStep).int()

		if newSliderValue >= 0 {
			users[i].selectionState = .locked
		}
		users[i].amountValue = amountValue(intNewSplitValue)
		users[i].splitValue = intNewSplitValue
		users[i].sliderValue = newSliderValue.bounded(-0.1, 1)

		sliderUnselect(userIndex: i)
		splitSelectedAmount()
		splitRemainderLocked(except: i)
	}

	func updateUserExactAmount (absoluteDifference: Int, userId: UUID) {
		guard let i = users.firstIndex(where: { $0.id == userId }) else { return }
		let newAmountValue = (users[i].amountValue + absoluteDifference).bounded(0, totalAmountValue)

		users[i].selectionState = .locked
		updateUserAmountValue(amountValue: newAmountValue, index: i)

		splitSelectedAmount()
	}

	func updateUserPercentAmount (absoluteDifference: Int, userId: UUID) {
		guard let i = users.firstIndex(where: { $0.id == userId }) else { return }
		let newSplitValue = (users[i].splitValue + absoluteDifference).bounded(0, maxPercentValue)

		users[i].selectionState = .locked
		updateUserSplitValue(splitValue: newSplitValue, index: i)

		splitSelectedAmount()
	}

	func updateUserPartsAmount (absoluteDifference: Int, userId: UUID) {
		guard let i = users.firstIndex(where: { $0.id == userId }) else { return }

		let newSplitValue = (users[i].splitValue + absoluteDifference).bounded(0, maxPercentValue)

		users[i].selectionState = .locked

		updateUserPartsSplitAmountValue(splitValue: newSplitValue, index: i)

		splitPartsRemainder()
		splitSelectedAmount()
		splitRemainderLocked()
	}
}

private extension AmountValueSplitInteractor {
	func sliderUnselect (userIndex: Int) {
		if users[userIndex].sliderValue < -0.05 {
			users[userIndex].selectionState = .unselected
		}
	}
}

private extension AmountValueSplitInteractor {
	func splitSelectedAmount () {
		if splitMode == .parts {
			if inputPartCount != nil {
				splitParts()
				splitRemainder()
				splitPartsRemainder()
			} else {
				splitRemainder()
				splitRemainderLocked()
			}
		} else {
			splitAmountValueEqually()
			splitRemainder()
			refreshSelectedSplitValues()
		}
	}

	func splitAmountValueEqually () {
		users.indices.forEach {
			updateUserWithEqualAmount(index: $0)
		}
	}

	func updateUserWithEqualAmount (index: Int) {
		switch users[index].selectionState {
		case .unselected:
			users[index].amountValue = 0

		case .selected:
			users[index].amountValue = equallyDividedUnlockedAmountValue

		case .locked:
			break
		}
	}

	func splitRemainder () {
		var remainder = totalAmountValue - usersAmountValue

		users.iterate(where: { remainder > 0 && users[$0].selectionState.isSelected }) {
			updateWithRemainder(index: $0, remainder: &remainder)
		}
	}

	func splitRemainderLocked (except userIndex: Int? = nil) {
		var remainder = totalAmountValue - usersAmountValue

		users.iterate(
			where: {
				remainder > 0 &&
				users[$0].selectionState.isSelectedOrLocked &&
				users[$0].splitValue != 0 &&
				(userIndex == nil || $0 != userIndex)
			}
		) {
			updateWithRemainder(index: $0, remainder: &remainder)
		}
	}

	func splitPartsRemainder () {
		var remainder = partCount - usersSplitValue

		users.iterate(where: { remainder > 0 && users[$0].selectionState.isSelected }) {
			users[$0].splitValue += 1

			let amountValue = amountValue(users[$0].splitValue)

			users[$0].amountValue = amountValue
			users[$0].sliderValue = sliderValue(amountValue)

			remainder -= 1
		}
	}

	func updateWithRemainder (index: Int, remainder: inout Int) {
		users[index].amountValue += 1
		users[index].sliderValue += 0.01
		remainder -= 1
	}

	func refreshSelectedSplitValues () {
		users.indices.forEach {
			refreshSelectedSplitValue(index: $0)
		}
	}

	func refreshSelectedSplitValue (index: Int) {
		switch users[index].selectionState {
		case .unselected:
			resetUserSplitValue(index: index)

		case .selected:
			refreshUserSplitValue(index: index)

		case .locked:
			break
		}
	}

	func refreshLockedSplitValues () {
		users.indices.forEach {
			refreshLockedSplitValue(index: $0)
		}
	}

	func refreshLockedSplitValue (index: Int) {
		switch users[index].selectionState {
		case .unselected, .selected:
			break

		case .locked:
			refreshUserSplitValue(index: index)
		}
	}

	func resetUserSplitValue (index: Int) {
		users[index].splitValue = 0
		users[index].sliderValue = 0
	}

	func refreshUserSplitValue (index: Int) {
		let amountValue = users[index].amountValue
		users[index].splitValue = splitValue(amountValue)
		users[index].sliderValue = sliderValue(amountValue)
	}

	func updateUserAmountValue (amountValue: Int, index: Int) {
		users[index].amountValue = amountValue
		users[index].splitValue = splitValue(amountValue)
		users[index].sliderValue = sliderValue(amountValue)
	}

	func updateUserSplitValue (splitValue: Int, index: Int) {
		let amountValue = amountValue(splitValue)

		users[index].amountValue = amountValue
		users[index].splitValue = splitValue
		users[index].sliderValue = sliderValue(amountValue)
	}

	func updateUserPartsSplitAmountValue (splitValue: Int, index: Int) {
		users[index].splitValue = splitValue
		let amountValue = amountValue(splitValue)
		users[index].amountValue = amountValue
		users[index].sliderValue = sliderValue(amountValue)

		users.indices.forEach {
			users[$0].amountValue = self.amountValue(users[$0].splitValue)
		}
	}

	func splitParts () {
		users.indices.forEach {
			updateUserWithEqualParts(index: $0)
		}
	}

	func updateUserWithEqualParts (index: Int) {
		switch users[index].selectionState {
		case .unselected:
			users[index].splitValue = 0
			users[index].amountValue = 0
			users[index].sliderValue = 0

		case .selected:
			users[index].splitValue = ((partCount - lockedSplitValue) / selectedUsers.count).bounded(0, partCount)
			users[index].amountValue = amountValue(users[index].splitValue)
			users[index].sliderValue = sliderValue(users[index].amountValue)

		case .locked:
			break
		}
	}
}

private extension AmountValueSplitInteractor {
	func splitValue (_ amountValue: Int) -> Int {
		switch splitMode {
		case .exact:
			return amountValue

		case .percent where usersAmountValue == 0:
			return 0

		case .percent:
			return (amountValue.double() / totalAmountValue.double()).intPercentValue.bounded(0, maxPercentValue)

		case .parts:
			return amountValue
		}
	}

	func sliderValue (_ amountValue: Int) -> Double {
		amountValue.doubleExactValue / totalAmountValue.doubleExactValue
	}

	func amountValue (_ splitValue: Int) -> Int {
		switch splitMode {
		case .exact:
			return splitValue

		case .percent:
			return (splitValue.doublePercentValue * totalAmountValue.doubleExactValue).intExactValue

		case .parts where usersSplitValue == 0:
			return 0

		case .parts:
			return (totalAmountValue.doubleExactValue * (splitValue.doubleExactValue / partCount.doubleExactValue)).intExactValue
		}
	}
}
