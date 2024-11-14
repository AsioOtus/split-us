import SwiftUI

public extension LocalizedStringKey {
	var key: String {
		Mirror(reflecting: self)
			.children
			.first { $0.0 == "key" }!
			.value as! String
	}
}
