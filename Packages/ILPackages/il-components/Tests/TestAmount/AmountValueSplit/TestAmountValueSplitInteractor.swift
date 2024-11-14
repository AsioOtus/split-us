import XCTest
import DLModelsSamples
import Multitool
@testable import ILComponents

final class TestAmountValueSplitInteractor: XCTestCase {
	var sut: AmountValueSplitInteractor!

	var userA = SplitUser(
		user: .empty(id: .create(0)),
		selectionState: .unselected,
		splitValue: 0,
		amountValue: 0,
		sliderValue: 0
	)

	var userB = SplitUser(
		user: .empty(id: .create(1)),
		selectionState: .unselected,
		splitValue: 0,
		amountValue: 0,
		sliderValue: 0
	)

	var userC = SplitUser(
		user: .empty(id: .create(1)),
		selectionState: .unselected,
		splitValue: 0,
		amountValue: 0,
		sliderValue: 0
	)

	override func setUpWithError() throws {
		sut = .init(
			users: [],
			totalAmountValue: 0,
			splitMode: .exact,
			inputPartCount: 0,
			currency: .eur
		)
	}

	override func tearDownWithError() throws { }

	func testPercentModeSelection () {
		sut.splitMode = .exact

		sut.onSplitModeChanged(.percent)

		XCTAssert(sut.splitMode == .percent)
	}

	func testLockedUserSelection () {
		sut.users = [userA.set(\.selectionState, .locked)]

		sut.onUserSelectionToggle(userId: userA.id)

		XCTAssert(sut.users.map(\.selectionState) == [.locked])
	}

	func testIncrementWithTotalAMount100 () {
		sut.totalAmountValue = 100
		sut.users = [userA.set(\.amountValue, 0).set(\.selectionState, .unselected)]

		sut.onIncrement(userId: userA.id)

		XCTAssert(sut.users.map(\.amountValue) == [1])
		XCTAssert(sut.users.map(\.selectionState) == [.locked])
	}

	func testIncrementWithTotalAMount15000 () {
		sut.totalAmountValue = 15000
		sut.users = [userA.set(\.amountValue, 0).set(\.selectionState, .unselected)]

		sut.onIncrement(userId: userA.id)

		XCTAssert(sut.users.map(\.amountValue) == [50])
		XCTAssert(sut.users.map(\.selectionState) == [.locked])
	}

	func testIncrementWithAnotherSelectedUsers () {
		sut.totalAmountValue = 15000
		sut.users = [
			userA.set(\.amountValue, 0).set(\.selectionState, .unselected),
			userB.set(\.selectionState, .selected),
			userC.set(\.selectionState, .selected),
		]

		sut.onIncrement(userId: userA.id)

		XCTAssert(sut.users.map(\.amountValue) == [50, (15000 - 50) / 2, (15000 - 50) / 2])
		XCTAssert(sut.users.map(\.selectionState) == [.locked, .selected, .selected])
	}
}
