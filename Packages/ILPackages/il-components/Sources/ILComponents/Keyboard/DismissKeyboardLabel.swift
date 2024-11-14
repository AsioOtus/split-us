import ILLocalization
import SwiftUI

public struct DismissKeyboardLabel: View {
	private let text: LocalizedStringKey

	public init (text: LocalizedStringKey = .generalDone) {
		self.text = text
	}

	public var body: some View {
		Label(text, systemImage: "keyboard.chevron.compact.down")
	}
}
