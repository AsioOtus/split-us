import SwiftUI

struct StepperView: View {
	let onIncrement: () -> Void
	let onDecrement: () -> Void

	var body: some View {
		HStack(spacing: 0) {
			buttonView(systemImage: "minus", action: onDecrement)
			Divider()
			buttonView(systemImage: "plus", action: onIncrement)
		}
	}
}

private extension StepperView {
	func buttonView (systemImage: String, action: @escaping () -> Void) -> some View {
		Button(action: action) {
			Image(systemName: systemImage)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.contentShape(.rect)
		}
		.buttonRepeatBehavior(.enabled)
		.buttonStyle(.borderless)
		.labelStyle(.iconOnly)
	}
}

#Preview {
	StepperView(onIncrement: { }, onDecrement: { })
}
