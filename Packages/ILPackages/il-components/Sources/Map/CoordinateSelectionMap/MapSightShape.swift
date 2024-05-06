import SwiftUI

struct MapSightShape: Shape {
	func path (in r: CGRect) -> Path {
		var path = Path()

		path.move(to: .init(x: r.minX, y: r.midY))
		path.addLine(to: .init(x: r.midX / 2, y: r.midY))
		path.move(to: .init(x: r.midX + r.midX / 2, y: r.midY))
		path.addLine(to: .init(x: r.maxX, y: r.midY))

		path.move(to: .init(x: r.midX, y: r.midY + r.midY / 2))
		path.addLine(to: .init(x: r.midX, y: r.maxY))

		return path
	}
}
