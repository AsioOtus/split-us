import SwiftUI

public struct AcronymView <Background: ShapeStyle, Foreground: ShapeStyle, Stroke: ShapeStyle>: View {
	let acronymText: Text
	let background: Background
	let foreground: Foreground
	let stroke: Stroke

	public init (
		acronym: Text,
		background: Background,
		foreground: Foreground = .background,
		stroke: Stroke
	) {
		self.acronymText = acronym
		self.background = background
		self.foreground = foreground
		self.stroke = stroke
	}

	public init (
		acronym: String,
		background: Background,
		foreground: Foreground = .background,
		stroke: Stroke
	) {
		self.acronymText = .init(verbatim: acronym)
		self.background = background
		self.foreground = foreground
		self.stroke = stroke
	}

	public var body: some View {
		AvatarLayoutView(
			background: background,
			foreground: foreground,
			stroke: stroke
		) {
			acronymText
		}
	}
}

let avatarSizes = [10, 20, 50, 100, 150, 200].map(AvatarSize.init)

#Preview(traits: .sizeThatFitsLayout) {
	VStack {
		HStack {
			ForEach(["AB", "OO", "QB", "qb", "II", "ii", "a", "+", "?", "X"], id: \.self) { acronym in
				VStack {
					ForEach(avatarSizes, id: \.self) { size in
						AcronymView(acronym: acronym, background: .blue, stroke: .blue.secondary)
							.avatarSize(size)
					}
				}
			}
		}

		HStack {
			ForEach(["666", "XXX", "X+x"], id: \.self) { acronym in
				VStack {
					ForEach(avatarSizes, id: \.self) { size in
						AcronymView(acronym: acronym, background: .blue, stroke: .blue.secondary)
							.avatarSize(size)
					}
				}
			}
		}

		HStack {
			ForEach(["plus", "questionmark"], id: \.self) { acronym in
				VStack {
					ForEach(avatarSizes, id: \.self) { size in
						AcronymView(acronym: Text(Image(systemName: acronym)), background: .blue, stroke: .blue.secondary)
							.avatarSize(size)
					}
				}
			}
		}
	}
}
