import Foundation

public enum ExpenseUnit<E, EG> {
	case expense(E)
	case expenseGroup(EG)

	public var isExpense: Bool {
		if case .expense = self { true }
		else { false }
	}

	public var isExpenseGroup: Bool {
		if case .expenseGroup = self { true }
		else { false }
	}

	public var expenseValue: E? {
		if case .expense(let e) = self { return e }
		else { return nil }
	}

	public var expenseGroupValue: EG? {
		if case .expenseGroup(let eg) = self { return eg }
		else { return nil }
	}
}

extension ExpenseUnit: Identifiable where E: Identifiable<UUID>, EG: Identifiable<UUID> {
	public var id: UUID {
		switch self {
		case .expense(let e): e.id
		case .expenseGroup(let eg):  eg.id
		}
	}
}

extension ExpenseUnit: Codable where E: Codable, EG: Codable { }
extension ExpenseUnit: Equatable where E: Equatable, EG: Equatable { }
extension ExpenseUnit: Hashable where E: Hashable, EG: Hashable { }
