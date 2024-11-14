import SwiftUI

extension ControlSize {
	var amountViewFontSize: Double {
		switch self {
		case .mini: 12
		case .small: 14
		case .regular: 16
		case .large: 20
		case .extraLarge: 28
		@unknown default: 16
		}
	}
	
	var amountViewPadding: Double {
		switch self {
		case .mini: 0
		case .small: 3
		case .regular: 4
		case .large: 6
		case .extraLarge: 8
		@unknown default: 4
		}
	}
}
