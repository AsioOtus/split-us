import SwiftUI

public extension View {
	func horizontallyCentered () -> some View {
		frame(maxWidth: .infinity, alignment: .center)
	}
}
