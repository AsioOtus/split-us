import Foundation
import Multitool

public struct TransferGroup: Identifiable, Hashable, Codable {
	public let id: UUID
	public let info: TransferUnit.Info
	
	public init (
		id: UUID,
		info: TransferUnit.Info
	) {
		self.id = id
		self.info = info
	}
}

public extension TransferGroup {
	var new: New {
		.init(
			info: info
		)
	}
	
	var update: Update {
		.init(
			id: id,
			info: info
		)
	}
}

public extension Array where Element == TransferUnit {
	var amounts: [Amount] {
		flatMap { $0.amounts }.compactMap { $0 }
	}
	
	var amountsSum: [Amount] {
		var dictionary = [Currency: Int]()
		amounts
			.compactMap { $0 }
			.forEach { dictionary[$0.currency, default: 0] += $0.valueOrZero }
		
		let amountsSum = dictionary.map { currency, value in Amount(value: value, currency: currency) }
		return amountsSum
	}
	
	var singleCurrency: Currency? {
		amountsSum.count == 1 ? amountsSum.first?.currency : nil
	}
	
	var isSingleCurrency: Bool {
		singleCurrency != nil
	}
	
	var creditors: [User.Compact] {
		flatMap { $0.creditors }.compactMap { $0 }
	}
	
	var uniqueCreditors: Set<User.Compact> {
		.init(creditors)
	}
	
	var singleCreditor: User.Compact? {
		uniqueCreditors.count == 1 ? uniqueCreditors.first : nil
	}
	
	var isSingleCreditor: Bool {
		singleCreditor != nil
	}
	
	var borrowers: [User.Compact] {
		flatMap { $0.borrowers }.compactMap { $0 }
	}
	
	var uniqueBorrowers: Set<User.Compact> {
		.init(borrowers)
	}
	
	var hasDuplicatedBorrowers: Bool {
		uniqueBorrowers.count != borrowers.count
	}
}
