import SwiftUI

public extension View {
	func dismissKeyboardToolbar () -> some View {
		toolbar {
			dismissKeyboardToolbarItemGroup()
		}
	}
}
