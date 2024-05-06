import SwiftUI

extension ControlSize {
	var userImageSize: Double {
		switch self {
		case .mini: 16
		case .small: 20
		case .regular: 28
		case .large: 36
		case .extraLarge: 72
		@unknown default: 28
		}
	}
}
