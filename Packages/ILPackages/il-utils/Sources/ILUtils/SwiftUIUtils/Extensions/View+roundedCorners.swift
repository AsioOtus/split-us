import SwiftUI

#if canImport(UIKit)
public extension View {
	func roundedCorners (_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> some View {
		clipShape(PartlyRoundedRectangle(radius: radius, corners: corners))
	}
}
#endif
