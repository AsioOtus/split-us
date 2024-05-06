import ILLocalization
import DLModels
import SwiftUI

public struct SumEditingView: View {
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
			Text(.domainSum)
			
			Spacer()
			
			AmountInputView(amountValue: $amountValue, currency: currency)
		}
	}
}
