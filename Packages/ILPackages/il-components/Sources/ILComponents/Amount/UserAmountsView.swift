import SwiftUI

public struct UserAmountsView<UserView, AmountsView>: View
where UserView: View, AmountsView: View
{
	let userView: () -> UserView
	let amountsView: () -> AmountsView
	
	public init (
		@ViewBuilder userView: @escaping () -> UserView,
		@ViewBuilder amountsView: @escaping () -> AmountsView
	) {
		self.userView = userView
		self.amountsView = amountsView
	}
	
	public var body: some View {
		HStack {
			userView()
			Spacer()
			amountsView()
		}
	}
}
