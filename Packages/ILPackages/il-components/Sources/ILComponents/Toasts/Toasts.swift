import AlertToast
import ILUtils
import SwiftUI

public enum Toasts {
	public static func error (message: LocalizedStringKey) -> AlertToast {
		.init(
			displayMode: .hud,
			type: .systemImage("exclamationmark.octagon", .red),
			title: message.key
		)
	}

	public static func regular (message: LocalizedStringKey, systemImage: String) -> AlertToast {
		.init(displayMode: .hud, type: .systemImage(systemImage, .cyan), title: message.key)
	}
}
