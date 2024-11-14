import SwiftUI

extension AmountView {
	public struct Appearance {
		let backgroundColor: Color
		let foregroundColor: Color
		let borderColor: Color

		public var disabled: Self {
			.init(
				backgroundColor: backgroundColor.opacity(0.5),
				foregroundColor: foregroundColor.opacity(0.5),
				borderColor: borderColor.opacity(0.5)
			)
		}

		public init (
			backgroundColor: Color,
			foregroundColor: Color,
			borderColor: Color
		) {
			self.backgroundColor = backgroundColor
			self.foregroundColor = foregroundColor
			self.borderColor = borderColor
		}

		public static let neutral = Self(
			backgroundColor: .amountviewBackgroundNeutral,
			foregroundColor: .amountviewForegroundNeutral,
			borderColor: .amountviewBorderNeutral
		)

		public static let positive = Self(
			backgroundColor: .amountviewBackgroundPositive,
			foregroundColor: .amountviewForegroundPositive,
			borderColor: .amountviewBorderPositive
		)

		public static let negative = Self(
			backgroundColor: .amountviewBackgroundNegative,
			foregroundColor: .amountviewForegroundNegative,
			borderColor: .amountviewBorderNegative
		)
	}
}

extension AmountView.Appearance {
	enum EnvironmentKey: SwiftUI.EnvironmentKey {
		static var defaultValue = AmountView.Appearance.neutral
	}
}

public extension EnvironmentValues {
	var amountViewAppearance: AmountView.Appearance {
		get { self[AmountView.Appearance.EnvironmentKey.self] }
		set { self[AmountView.Appearance.EnvironmentKey.self] = newValue }
	}
}

public extension View {
	func amountViewAppearance (
		_ amountViewAppearance: AmountView.Appearance
	) -> some View {
		environment(\.amountViewAppearance, amountViewAppearance)
	}
}
