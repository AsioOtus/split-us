import SwiftUI

#if canImport(UIKit)
public struct PartlyRoundedRectangle: Shape {
	public let radius: CGFloat
	public let corners: UIRectCorner
	
	public init (
		radius: CGFloat = 0,
		corners: UIRectCorner = .allCorners
	) {
		self.radius = radius
		self.corners = corners
	}
	
	public func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(
			roundedRect: rect,
			byRoundingCorners: corners,
			cornerRadii: .init(
				width: radius,
				height: radius
			)
		)
		
		return Path(path.cgPath)
	}
}
#endif
