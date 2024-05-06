import Foundation
import DLModels

public struct SplitUser: Equatable {
	public let user: User.Compact
	var selectionState: SelectionState
	var splitValue: Int
	var amountValue: Int
	var sliderValue: Double

	public var id: UUID { user.id }

	public init (
		user: User.Compact,
		selectionState: SelectionState,
		splitValue: Int,
		amountValue: Int,
		sliderValue: Double
	) {
		self.user = user
		self.selectionState = selectionState
		self.splitValue = splitValue
		self.amountValue = amountValue
		self.sliderValue = sliderValue
	}

	public init (user: User.Compact) {
		self.init(
			user: user,
			selectionState: .unselected,
			splitValue: 0,
			amountValue: 0,
			sliderValue: 0
		)
	}
}

extension SplitUser {
	mutating func reset () {
		splitValue = 0
		amountValue = 0
		sliderValue = 0
	}
}
