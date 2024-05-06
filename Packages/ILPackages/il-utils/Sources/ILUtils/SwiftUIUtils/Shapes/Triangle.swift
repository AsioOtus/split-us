import SwiftUI

public struct LeftTriangle: Shape {
	public init () { }
	
	public func path (in rect: CGRect) -> Path {
		var path = Path()
		
		path.move(to: CGPoint(x: rect.minX, y: rect.midY))
		path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
		path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
		path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
		
		return path
	}
}

#Preview {
	LeftTriangle()
}
