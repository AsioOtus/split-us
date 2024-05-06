import SwiftUI

#if canImport(UIKit)
public extension UIRectCorner {
	static var top: UIRectCorner { [.topLeft, .topRight] }
	static var right: UIRectCorner { [.topRight, .bottomRight] }
	static var bottom: UIRectCorner { [.bottomLeft, .bottomRight] }
	static var left: UIRectCorner { [.topLeft, .bottomLeft] }
}
#endif
