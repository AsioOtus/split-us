import DLModels
import DLModelsSamples
import SwiftUI

public struct AmountEditingView: View {
	@Binding var amountValue: Int?
	@Binding var currency: Currency
	
	public init (
		amountValue: Binding<Int?>,
		currency: Binding<Currency>
	) {
		self._amountValue = amountValue
		self._currency = currency
	}
	
	public var body: some View {
		HStack {
			AmountValueEditingView(amountValue: $amountValue)
			
			Divider()
				.fixedSize()

			CurrencySelectionView(currencies: [.eur, .usd, .rub], currency: $currency)
				.fixedSize()
		}
		.bordered()
	}
}
