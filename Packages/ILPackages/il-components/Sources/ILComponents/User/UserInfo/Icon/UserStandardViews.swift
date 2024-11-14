import SwiftUI

public enum UserStandardViews {
	public static func unknownUser (title: LocalizedStringKey) -> some View {
		UserUnknownView(title: title)
	}
}

struct UserUnknownView: View {
	let title: LocalizedStringKey

	var body: some View {
		HStack(spacing: 4) {
			UserMinimalView.unknown()
			Text(title)
		}
	}
}

#Preview {
	UserStandardViews.unknownUser(title: .componentsUserUndistributed)
}
