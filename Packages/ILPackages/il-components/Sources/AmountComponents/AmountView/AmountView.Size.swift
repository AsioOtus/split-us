import SwiftUI

extension AmountView {
	public struct Size {
		let padding: Double

		public init (padding: Double) {
			self.padding = padding
		}
	}
}

extension AmountView.Size {
	enum EnvironmentKey: SwiftUI.EnvironmentKey {
		static var defaultValue = AmountView.Size(padding: ControlSize.regular.fontSize)
	}
}

public extension EnvironmentValues {
	var amountViewSize: AmountView.Size {
		get { self[AmountView.Size.EnvironmentKey.self] }
		set { self[AmountView.Size.EnvironmentKey.self] = newValue }
	}
}

public extension View {
	func amountViewSize (
		_ size: AmountView.Size
	) -> some View {
		environment(\.amountViewSize, size)
	}

	func amountViewSize (
		_ controlSize: ControlSize
	) -> some View {
		environment(\.amountViewSize, .init(padding: controlSize.fontSize))
	}
}
