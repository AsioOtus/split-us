import ILModels
import SwiftUI

public struct UserImage: View {
	let userInfo: UserScreenModel

	public init (userInfo: UserScreenModel) {
		self.userInfo = userInfo
	}

	public var body: some View {
		if let uiImage = ImageRenderer(content: imageView()).uiImage {
			Image(uiImage: uiImage)
				.resizable()
		} else {
			Image(systemName: "person.fill")
				.resizable()
		}
	}

	private func imageView () -> some View {
		UserMinimalView(user: userInfo)
	}
}
