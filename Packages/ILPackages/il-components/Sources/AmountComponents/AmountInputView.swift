import DLModels
import SwiftUI

public struct AmountInputView: View {
	@Binding var amountValue: Double?
	let currency: Currency
	
	public init (
		amountValue: Binding<Double?>,
		currency: Currency
	) {
		self._amountValue = amountValue
		self.currency = currency
	}
	
	public var body: some View {
		HStack {
			TextField("", value: $amountValue, format: .number, prompt: Text("0"))
				.multilineTextAlignment(.trailing)
				.keyboardType(.decimalPad)
			
			Text(currency.code)
		}
	}
}
