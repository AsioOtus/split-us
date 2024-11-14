import SwiftUI

public struct AmountSumEditingView: View {
	@Binding var perItemAmountValue: Int?
	@Binding var itemCount: Int?
	let totalAmountValueFormatted: String
	let currencyCode: String

	public init (
		perItemAmountValue: Binding<Int?>,
		itemCount: Binding<Int?>,
		totalAmountValueFormatted: String,
		currencyCode: String
	) {
		self._perItemAmountValue = perItemAmountValue
		self._itemCount = itemCount
		self.totalAmountValueFormatted = totalAmountValueFormatted
		self.currencyCode = currencyCode
	}

	public var body: some View {
		HStack {
			Spacer(minLength: 0)

			TextField(
				"",
				value: $perItemAmountValue.map(
					get: { $0?.doubleExactValue },
					set: { $0?.intExactValue }
				),
				format: .currency(code: currencyCode)
			)
				.keyboardType(.decimalPad)
				.multilineTextAlignment(.center)

			Image(systemName: "multiply")

			TextField("", value: $itemCount, format: .number)
				.keyboardType(.numberPad)
				.frame(minWidth: 50)
				.fixedSize()
				.multilineTextAlignment(.center)

			Image(systemName: "equal")

			AmountView(totalAmountValueFormatted)
		}
	}
}
