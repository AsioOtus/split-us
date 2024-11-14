import Foundation

public enum ExpenseUnitSource: Hashable { // TODO: Remove
	case userGroup(UUID)
	case superExpenseGroup(UUID)
}
