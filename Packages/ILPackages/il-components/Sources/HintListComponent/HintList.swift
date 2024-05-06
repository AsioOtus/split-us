import ILLocalization
import SwiftUI

extension HintList {
	public struct State {
		public let title: LocalizedStringKey
		public let hints: [Hint]
		
		public init (
			title: LocalizedStringKey,
			hints: [Hint]
		) {
			self.title = title
			self.hints = hints
		}
		
		public struct Hint: Identifiable {
			public let id: String
			public let text: LocalizedStringKey
			public let iconName: String
			public let appearance: Appearance
			
			public init (
				id: String,
				text: LocalizedStringKey,
				iconName: String,
				appearance: Appearance
			) {
				self.id = id
				self.text = text
				self.iconName = iconName
				self.appearance = appearance
			}
		}
	}
}

extension HintList {
	public enum Appearance: Hashable {
		case completed
		case uncompleted
		case warning
		case invalid
	}
}

public struct HintList: View {
	let state: State
	
	public init (state: State) {
		self.state = state
	}
	
	public var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			titleView()
			
			hintsView()
				.padding(.leading, 8)
		}
		.font(.footnote)
		.transition(.opacity)
	}
}

private extension HintList {
	func titleView () -> some View {
		Text(state.title)
	}
	
	func hintsView () -> some View {
		VStack(alignment: .leading, spacing: 12) {
			ForEach(state.hints) { hint in
				hintView(hint: hint)
			}
		}
	}
	
	func hintView (hint: State.Hint) -> some View {
		HStack(alignment: .firstTextBaseline) {
			Image(systemName: hint.iconName)
				.font(.system(size: 15))
				.offset(y: 1)
			Text(hint.text)
		}
		.foregroundStyle(hint.appearance.color)
	}
}

fileprivate extension HintList.Appearance {
	var color: Color {
		switch self {
		case .completed: .green
		case .uncompleted: .gray
		case .warning: .orange
		case .invalid: .red
		}
	}
}

#Preview {
	List {
		HintList(
			state: .init(
				title: .registrationPasswordHintIntro,
				hints: [
					.init(
						id: "1",
						text: .registrationPasswordHintPointDigits,
						iconName: "ruler.fill",
						appearance: .completed
					),
					.init(
						id: "2",
						text: .registrationPasswordHintPointDigits,
						iconName: "ruler",
						appearance: .uncompleted
					),
					.init(
						id: "3",
						text: .registrationPasswordHintPointNonLowerCaseCharacter,
						iconName: "at.circle.fill",
						appearance: .completed
					),
					.init(
						id: "4",
						text: .registrationPasswordHintPointNonLowerCaseCharacter,
						iconName: "at.circle",
						appearance: .uncompleted
					),
				]
			)
		)
	}
}
