import SwiftUI

public struct OverlappableHStack: Layout {
	public let spacing: Double
	public let overlapThreshold: Double
	
	public init (
		spacing: Double = 0,
		overlapThreshold: Double = 0.5
	) {
		self.spacing = spacing
		self.overlapThreshold = overlapThreshold  > 1
		? 1
		: overlapThreshold < 0
		? 0
		: overlapThreshold
	}
}

extension OverlappableHStack {
	public func sizeThatFits (
		proposal: ProposedViewSize,
		subviews: Subviews,
		cache: inout ()
	) -> CGSize {
		let subviewsWidth = subviews.widths.reduce(0, +)
		let spacingWidth = Double(subviews.gapsCount) * spacing
		let maxWidth = subviewsWidth + spacingWidth
		let maxHeight = subviews.map { $0.dimensions(in: .unspecified).height }.max()
		return .init(width: min(proposal.width ?? .infinity, maxWidth), height: maxHeight ?? 0)
	}
}

extension OverlappableHStack {
	public func placeSubviews (
		in bounds: CGRect,
		proposal: ProposedViewSize,
		subviews: Subviews,
		cache: inout ()
	) {
		let subviewsWidth = subviews.widths.reduce(0, +)
		let spacingWidth = Double(subviews.gapsCount) * spacing
		let difference = subviewsWidth + spacingWidth - bounds.width
		
		if difference <= 0 {
			placeSubviews(in: bounds, subviews: subviews)
		} else {
			placeSubviewsWithOverlap(in: bounds, subviews: subviews, difference: difference)
		}
	}
	
	func placeSubviews (
		in bounds: CGRect,
		subviews: Subviews
	) {
		var point = bounds.origin
		
		for subview in subviews {
			subview.place(at: point, anchor: .topLeading, proposal: .unspecified)
			point.x += subview.dimensions(in: .unspecified).width + spacing
		}
	}
	
	func placeSubviewsWithOverlap (
		in bounds: CGRect,
		subviews: Subviews,
		difference: Double
	) {
		let differencePerView = difference / Double(subviews.count - 1)
		
		var point = bounds.origin
		
		for subview in subviews {
			subview.place(at: point, anchor: .topLeading, proposal: .unspecified)
			
			let proposedOffset = subview.dimensions(in: .unspecified).width - differencePerView + spacing
			let thresholdWidth = (subview.width ?? 0) * overlapThreshold
			let offset = proposedOffset <= thresholdWidth ? thresholdWidth : proposedOffset
			point.x += max(offset, 0)
		}
	}
}

fileprivate extension LayoutSubviews.Element {
	var width: Double? {
		dimensions(in: .unspecified).width
	}
}

fileprivate extension LayoutSubviews {
	var widths: [Double] {
		map { $0.dimensions(in: .unspecified).width }
	}
	
	var gapsCount: Int {
		count - 1
	}
}

fileprivate struct FPreview: View {
	@State var width = 100.0
	
	var body: some View {
		VStack {
			Slider(value: $width, in: 0...1000)
			OverlappableHStack {
				Color.red.frame(width: 50, height: 20).fixedSize()
				Color.green.frame(width: 50, height: 20).fixedSize()
				Color.blue.frame(width: 50, height: 20).fixedSize()
			}
			.frame(width: width)
		}
	}
}

#Preview {
	FPreview()
}
