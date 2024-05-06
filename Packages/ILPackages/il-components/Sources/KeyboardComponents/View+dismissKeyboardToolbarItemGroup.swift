import SwiftUI

public extension View {
	func dismissKeyboardToolbarItemGroup () -> some ToolbarContent {
		ToolbarItemGroup(placement: .keyboard) {
			Spacer()
			DismissKeyboardButton()
		}
	}
}
