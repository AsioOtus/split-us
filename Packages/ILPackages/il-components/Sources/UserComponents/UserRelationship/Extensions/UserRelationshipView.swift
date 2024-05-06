import SwiftUI

extension ControlSize {
	var userRelationshipPadding: Double {
		switch self {
		case .mini: 4
		case .small: 4
		case .regular: 8
		case .large: 10
		case .extraLarge: 12
		@unknown default: 8
		}
	}
}
