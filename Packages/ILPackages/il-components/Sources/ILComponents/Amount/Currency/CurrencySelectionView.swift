import DLModels
import Multitool
import SwiftUI

struct CurrencySelectionView: View {
	let currencies: [Currency]
	@Binding var currency: Currency

	var body: some View {
		Picker("", selection: $currency) {
			ForEach(currencies, id: \.self) { currency in
				Text(currency.code.uppercased())
			}
		}
		.pickerStyle(.menu)
		.labelsHidden()
		.labelStyle(.iconOnly)
	}
}
