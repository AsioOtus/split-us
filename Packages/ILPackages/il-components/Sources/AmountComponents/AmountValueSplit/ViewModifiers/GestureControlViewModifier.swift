import SwiftUI
import DLUtils

struct GestureControlViewModifier: ViewModifier {
	@GestureState private var previousTranslationWidth: Double?
	@State private var contentSize: CGSize?

	let onSelectionToggle: () -> Void
	let onLockToggle: () -> Void
	let onValueChanged: (Double) -> Void
	let onValueChangingCompleted: () -> Void

	init (
		onSelectionToggle: @escaping () -> Void,
		onLockToggle: @escaping () -> Void,
		onValueChanged: @escaping (Double) -> Void,
		onValueChangingCompleted: @escaping () -> Void
	) {
		self.onSelectionToggle = onSelectionToggle
		self.onLockToggle = onLockToggle
		self.onValueChanged = onValueChanged
		self.onValueChangingCompleted = onValueChangingCompleted
	}

	private var tapGesture: some Gesture {
		TapGesture()
			.onEnded(onSelectionToggle)
	}

	private var doubleTapGesture: some Gesture {
		TapGesture(count: 2)
			.onEnded(onLockToggle)
	}

	private var longPressGesture: some Gesture {
		LongPressGesture()
			.onEnded { _ in onLockToggle() }
	}

	private var dragGesture: some Gesture {
		DragGesture()
			.updating($previousTranslationWidth) { value, state, _ in
				defer {
					state = value.translation.width
				}

				guard let contentSize else {
					return
				}
				guard let previousValue = state else {
					return
				}

				let widthDifference = value.translation.width - previousValue
				let percentWidthDifference = widthDifference / contentSize.width

				onValueChanged(percentWidthDifference)
			}
			.onEnded { _ in
				onValueChangingCompleted()
			}
	}

	private var combinedGesture: some Gesture {
		tapGesture
			.simultaneously(
				with: longPressGesture
					.exclusively(
						before: dragGesture
					)
			)
	}

	func body (content: Content) -> some View {
		content
			.size($contentSize)
			.gesture(combinedGesture)
	}
}

extension View {
	func gestureControl (
		onSelectionToggle: @escaping () -> Void,
		onLockToggle: @escaping () -> Void,
		onValueChanged: @escaping (Double) -> Void,
		onValueChangingCompleted: @escaping () -> Void
	) -> some View {
		modifier(
			GestureControlViewModifier(
				onSelectionToggle: onSelectionToggle,
				onLockToggle: onLockToggle,
				onValueChanged: onValueChanged,
				onValueChangingCompleted: onValueChangingCompleted
			)
		)
	}
}
