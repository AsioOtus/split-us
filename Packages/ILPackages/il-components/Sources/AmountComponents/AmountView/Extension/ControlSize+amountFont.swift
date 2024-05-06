import SwiftUI

extension ControlSize {
	var fontSize: Double {
		switch self {
		case .mini: 12
		case .small: 16
		case .regular: 20
		case .large: 24
		case .extraLarge: 28
		@unknown default: 20
		}
	}
}
