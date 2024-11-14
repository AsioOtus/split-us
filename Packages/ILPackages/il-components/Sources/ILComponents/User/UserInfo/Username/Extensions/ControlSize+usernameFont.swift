import SwiftUI

enum UsernameFont {
	case small
	case medium
}

extension ControlSize {
	var usernameFont: Font {
		switch self {
		case .mini: .footnote
		case .small: .footnote
		case .regular: .body
		case .large: .body
		case .extraLarge: .body
		@unknown default: .body
		}
	}
}
