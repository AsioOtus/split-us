import DLModels
import SwiftUI
import DLUtils

extension UserTokenView {
	public enum Mode {
		case regular
		case highlighted
		case selected
		case disabled
		case special
	}
}

public struct UserTokenView: View {
	let user: User
	let mode: Mode
	
	var foregroundColor: Color {
		switch mode {
		case .highlighted: return .white
		default: return .init(white: 0.1)
		}
	}
	
	var tintColor: Color {
		switch mode {
		case .highlighted: return .blue
		default: return .init(white: 0.8)
		}
	}
	
	public init (user: User, mode: UserTokenView.Mode = .regular) {
		self.user = user
		self.mode = mode
	}
	
	public  var body: some View {
		Text(user.username)
			.font(.system(size: 12))
			.token(foregroundColor: foregroundColor, tintColor: tintColor, cornerRadius: 4)
	}
}
