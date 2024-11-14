import SwiftUI

struct SelectionTapGestureViewModifier: ViewModifier {
	let doubleTapDelay = 0.25
	let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
	@State var lastTapTime: Date?

	let singleTapAction: () -> Void
	let doubleTapAction: () -> Void
	let doubleTapTimeoutAction: () -> Void

	init (
		singleTapAction: @escaping () -> Void,
		doubleTapAction: @escaping () -> Void,
		doubleTapTimeoutAction: @escaping () -> Void
	) {
		self.singleTapAction = singleTapAction
		self.doubleTapAction = doubleTapAction
		self.doubleTapTimeoutAction = doubleTapTimeoutAction
	}

	func body (content: Content) -> some View {
		content
			.onTapGesture {
				if let lastTapTime {
					resetState()

					let delay = Date.now.timeIntervalSince1970 - lastTapTime.timeIntervalSince1970

					if delay <= doubleTapDelay {
						doubleTapAction()
					} else {
						singleTapAction()
					}
				} else {
					self.lastTapTime = .now

					singleTapAction()
				}
			}
			.onReceive(timer) { _ in
				if let lastTapTime {
					let delay = Date.now.timeIntervalSince1970 - lastTapTime.timeIntervalSince1970

					if delay > doubleTapDelay {
						resetState()

						doubleTapTimeoutAction()
					}
				}
			}
	}

	func resetState () {
		lastTapTime = nil
	}
}

extension View {
	func selectionTapGesture (
		singleTapAction: @escaping () -> Void,
		doubleTapAction: @escaping () -> Void,
		doubleTapTimeoutAction: @escaping () -> Void
	) -> some View {
		modifier(
			SelectionTapGestureViewModifier(
				singleTapAction: singleTapAction,
				doubleTapAction: doubleTapAction,
				doubleTapTimeoutAction: doubleTapTimeoutAction
			)
		)
	}
}
