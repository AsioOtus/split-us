import ILUtils
import DLModels
import SwiftUI

public struct AmountStack <Amount, AmountView>: View
where
AmountView: View,
Amount: Hashable
{
	let amounts: [Amount]
	let amountView: (Amount) -> AmountView
	
	public init (
		amounts: [Amount],
		@ViewBuilder amountView: @escaping (Amount) -> AmountView
	) {
		self.amounts = amounts
		self.amountView = amountView
	}
	
	public var body: some View {
		WrappableHStack(alignment: .leading, fitContentWidth: true) {
			ForEach(amounts, id: \.self) { amount in
				amountView(amount)
			}
		}
	}
}
