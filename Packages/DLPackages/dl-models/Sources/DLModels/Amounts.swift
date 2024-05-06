public typealias Amounts = [Amount]

public extension Array where Element == Amount {
	func reduced () -> Self {
		var new = Self()

		for amount in self {
			if let amountIndex = new.firstIndex(where: { $0.currency == amount.currency }) {
				new[amountIndex] = new[amountIndex] + amount ?? new[amountIndex]
			} else {
				new.append(amount)
			}
		}

		return new
	}
}
