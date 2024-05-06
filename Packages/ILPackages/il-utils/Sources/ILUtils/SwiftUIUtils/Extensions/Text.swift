import SwiftUI

public extension Text {
	func token (
		foregroundColor: Color,
		tintColor: Color,
		cornerRadius: Double = 8,
		borderWidth: Double = 1,
		horizontalPadding: Double = 6,
		verticalPadding: Double = 2
	) -> some View {
		self
			.fontWeight(.light)
			.padding([.leading, .trailing], horizontalPadding)
			.padding([.top, .bottom], verticalPadding)
			.foregroundColor(foregroundColor)
			.background(tintColor.opacity(0.75))
			.cornerRadius(cornerRadius)
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(tintColor, lineWidth: borderWidth)
			)
	}

	func token (
		foregroundColor: Color,
		backgroundColor: Color,
		borderColor: Color = .clear,
		cornerRadius: Double = 8,
		borderWidth: Double = 1,
		horizontalPadding: Double = 4,
		verticalPadding: Double = 2
	) -> some View {
		self
			.fontWeight(.light)
			.padding([.leading, .trailing], horizontalPadding)
			.padding([.top, .bottom], verticalPadding)
			.foregroundColor(foregroundColor)
			.background(backgroundColor)
			.cornerRadius(cornerRadius)
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(borderColor, lineWidth: borderWidth)
			)
	}
}

public extension Text {
	func circled (
		foregroundColor: Color,
		tintColor: Color,
		fontSize: Double = 12,
		padding: Double = 6
	) -> some View {
		circled(
			foregroundColor: foregroundColor,
			backgroundColor: tintColor.opacity(0.5),
			borderColor: tintColor,
			fontSize: fontSize,
			padding: padding
		)
	}

	func circled (
		foregroundColor: Color,
		backgroundColor: Color,
		borderColor: Color,
		fontSize: Double = 12,
		padding: Double = 6
	) -> some View {
		self
			.font(.system(size: fontSize))
			.padding(padding)
			.foregroundColor(foregroundColor)
			.background(Circle().stroke(borderColor, lineWidth: 1))
			.background(Circle().fill(backgroundColor))
	}
}

public extension Text {
	func borderedToken (
		_ foregroundColor: Color
	) -> some View {
		self
			.foregroundColor(foregroundColor)
			.padding(.horizontal, 4)
			.padding(.vertical, 1)
			.overlay(
				RoundedRectangle(cornerRadius: 6)
					.stroke(foregroundColor, lineWidth: 0.8)
			)
	}
}

struct UserTokenView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Text("Test text")
				.token(foregroundColor: .white, tintColor: .blue)

			Text("Test text")
				.token(foregroundColor: .init(white: 0.2), tintColor: .init(white: 0.8))
		}
	}
}
