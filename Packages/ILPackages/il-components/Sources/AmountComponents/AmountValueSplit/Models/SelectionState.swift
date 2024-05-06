public enum SelectionState {
	case unselected
	case selected
	case locked

	var isUnselected: Bool { self == .unselected }
	var isSelected: Bool { self == .selected }
	var isLocked: Bool { self == .locked }

	var isSelectedOrLocked: Bool { isSelected || isLocked }

	public init (isSelected: Bool, isLocked: Bool) {
		switch (isSelected, isLocked) {
		case (false, false): self = .unselected
		case (false, true): self = .unselected
		case (true, false): self = .selected
		case (true, true): self = .locked
		}
	}

	mutating func safeSelect () {
		guard !self.isLocked else { return }
		self = .selected
	}

	mutating func safeUnselect () {
		guard !self.isLocked else { return }
		self = .unselected
	}

	mutating func safeToggleSelection () {
		switch self {
		case .unselected:
			self = .selected

		case .selected:
			self = .unselected

		case .locked:
			break
		}
	}

	mutating func forcedUnselectedLockToggle () {
		self = self.isLocked ? .unselected : .locked
	}

	mutating func forcedSelectedLockToggle () {
		self = self.isLocked ? .selected : .locked
	}
}
