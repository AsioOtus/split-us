import ILLocalization
import ILUtils
import SwiftUI

public struct DismissKeyboardButton: View {
	let text: LocalizedStringKey

	public init (text: LocalizedStringKey = .generalDone) {
		self.text = text
	}

	public var body: some View {
		Button(text) {
			KeyboardUtil.dismissKeyboard()
		}
		.fontWeight(.medium)
	}
}
