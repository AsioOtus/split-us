import Combine
import UIKit

public struct KeyboardUtil {
	public static var isKeyboardVisiblePublisher: AnyPublisher<Bool, Never> {
		Publishers.Merge(
			NotificationCenter.default
				.publisher(for: UIResponder.keyboardWillShowNotification)
				.map { _ in true },

			NotificationCenter.default
				.publisher(for: UIResponder.keyboardWillHideNotification)
				.map { _ in false }
		)
		.eraseToAnyPublisher()
	}
	
	public static func dismissKeyboard (completion: (() -> Void)? = nil) {
		let resign = #selector(UIResponder.resignFirstResponder)
		DispatchQueue.main.async {
			UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
			completion?()
		}
	}
}
