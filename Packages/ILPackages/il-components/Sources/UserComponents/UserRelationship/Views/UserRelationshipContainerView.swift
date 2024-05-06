import DLUtils
import ILUtils
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
		HStack(spacing: 0) {
			if isCreditorsVisible {
				usersView(roundCorners: .left, color: .green) {
					creditorsView
				}
			}

			relationshipView()

			if isBorrowersVisible {
				usersView(roundCorners: .right, color: .red) {
					borrowersView
				}
			}
		}
		.fixedSize()
	}
}

private extension UserRelationshipContainerView {
	func relationshipView () -> some View {
		LeftTriangle()
			.fill(.red)
			.background(isCreditorsVisible ? .green : .clear)
			.frame(width: 5)
	}

	@ViewBuilder
	func usersView <ContentView: View> (
		roundCorners: UIRectCorner,
		color: Color,
		@ViewBuilder contentView: () -> ContentView
	) -> some View {
		contentView()
			.padding(controlSize.userRelationshipPadding)
			.background(color)
			.roundedCorners(8, corners: roundCorners)
	}
}
