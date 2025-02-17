import ILDesignResources
import SwiftUI

public struct AmountView: View {
	@Environment(\.amountViewSize) private var amountViewSize
	@Environment(\.amountViewAppearance) private var environmentAppearance
	@Environment(\.controlSize) private var controlSize
	@Environment(\.isEnabled) private var isEnabled

	private var appearance: Appearance {
		isEnabled
			? environmentAppearance
			: environmentAppearance.disabled
	}

	let amount: String

	public init (_ amount: String) {
		self.amount = amount
	}

	public var body: some View {
		Text(amount)
			.font(.system(size: controlSize.amountViewFontSize))
			.fontDesign(.rounded)
			.fontWeight(.medium)
			.padding(.horizontal, amountViewSize.padding)
			.foregroundStyle(appearance.foregroundColor)
			.background(appearance.backgroundColor)
			.clipShape(.rect(cornerRadius: 4))
			.overlay {
				RoundedRectangle(cornerRadius: 4)
					.stroke(appearance.borderColor, lineWidth: 1)
			}
	}
}

#Preview {
	VStack(alignment: .leading, spacing: 10) {
		AmountView("100 €")
			.font(.system(size: 12))

		AmountView("$ 100")
			.font(.system(size: 24))
			.amountViewAppearance(.positive)

		AmountView("100 ₽")
			.font(.system(size: 48))
			.amountViewAppearance(.negative)
	}
}
