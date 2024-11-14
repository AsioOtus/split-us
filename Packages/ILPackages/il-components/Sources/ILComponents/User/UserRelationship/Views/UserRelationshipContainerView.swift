import ILUtils
import Multitool
import SwiftUI

public struct UserRelationshipContainerView <CreditorsView: View, BorrowersView: View>: View {
	@Environment(\.controlSize) private var controlSize
	@Environment(\.userRelationshipState) private var userRelationshipState

	let creditorsView: CreditorsView
	let borrowersView: BorrowersView

	var isCreditorsVisible: Bool {
		userRelationshipState != .hiddenCreditors
	}

	var isBorrowersVisible: Bool {
		userRelationshipState != .hiddenBorrowers
	}

	public init (creditorsView: () -> CreditorsView, borrowersView: () -> BorrowersView) {
		self.creditorsView = creditorsView()
		self.borrowersView = borrowersView()
	}

	public var body: some View {
		HStack(spacing: 1) {
			if isCreditorsVisible {
				usersView(
					roundCorners: .left,
					backgroundColor: .green.tertiary,
					strokeColor: .green.secondary
				) {
					creditorsView
				}
			}

			relationshipView()
				.padding([.leading, .trailing], 4)

			if isBorrowersVisible {
				usersView(
					roundCorners: .right,
					backgroundColor: .red.tertiary,
					strokeColor: .red.secondary
				) {
					borrowersView
				}
			}
		}
		.fixedSize()
	}
}

private extension UserRelationshipContainerView {
	func relationshipView () -> some View {
		Image(systemName: "chevron.compact.backward")
			.foregroundStyle(.tint)
	}

	@ViewBuilder
	func usersView <ContentView: View> (
		roundCorners: UIRectCorner,
		backgroundColor: some ShapeStyle,
		strokeColor: some ShapeStyle,
		@ViewBuilder contentView: () -> ContentView
	) -> some View {
		contentView()
	}
}
