import ILDesignResources
import SwiftUI

public struct RetryButton: View {
	let action: () -> Void

	public init (action: @escaping () -> Void) {
		self.action = action
	}

	public var body: some View {
		Button(action: action) {
			Label(.generalActionRetry, systemImage: .sinRetry)
		}
		.buttonStyle(.bordered)
		.buttonBorderShape(.roundedRectangle)
	}
}

#Preview {
	RetryButton { }
	.tint(.cyan)
}
