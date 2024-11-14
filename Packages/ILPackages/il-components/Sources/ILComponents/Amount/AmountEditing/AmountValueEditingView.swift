import SwiftUI

struct AmountValueEditingView: View {
	@Binding var amountValue: Int?

	public init (
		amountValue: Binding<Int?>
	) {
		self._amountValue = amountValue
	}

	var body: some View {
		TextField(
			"",
			value: $amountValue.map(
				get: { $0?.doubleExactValue },
				set: { $0?.intExactValue }
			),
			format: .number
		)
		.keyboardType(.decimalPad)
		.multilineTextAlignment(.trailing)
	}
}
