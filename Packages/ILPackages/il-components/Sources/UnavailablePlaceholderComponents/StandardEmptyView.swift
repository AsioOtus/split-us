import SwiftUI

public struct StandardEmptyView: View {
	let message: LocalizedStringKey
	let systemImage: String
	
	public init (
		message: LocalizedStringKey,
		systemImage: String
	) {
		self.message = message
		self.systemImage = systemImage
	}
	
	public var body: some View {
		ContentUnavailableView(message, systemImage: systemImage)
	}
}
