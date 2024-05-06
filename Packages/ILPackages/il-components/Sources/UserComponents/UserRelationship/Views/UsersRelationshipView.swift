import ILModels
import SwiftUI

public struct UsersRelationshipView: View {
	@Environment(\.controlSize) private var controlSize
	
	let creditors: [UserInfoModel]
	let borrowers: [UserInfoModel]
	
	public init (
		creditors: [UserInfoModel],
		borrowers: [UserInfoModel]
	) {
		self.creditors = creditors
		self.borrowers = borrowers
	}
	
	public var body: some View {
		UserRelationshipContainerView(
			creditorsView: {
				usersView(creditors)
			},
			borrowersView: {
				usersView(borrowers)
			}
		)
		.transformEnvironment(
			\.userRelationshipState,
			transform: transformUserRelationshipContainerState
		)
		.fixedSize()
	}
}

private extension UsersRelationshipView {
	func usersView (
		_ users: [UserInfoModel]
	) -> some View {
		UserHStack(
			users: users
		) { user in
			UserMinimalView(initials: user.initials, avatar: user.image)
		} truncatingView: { count in
			UserMinimalView(initials: "+" + count.description, avatar: nil)
		}
	}
}

private extension UsersRelationshipView {
	func transformUserRelationshipContainerState (
		_ userRelationshipState: inout UserRelationshipState?
	) {
		guard userRelationshipState == nil else { return }
		
		if creditors.isEmpty {
			userRelationshipState = .hiddenCreditors
		} else if borrowers.isEmpty {
			userRelationshipState = .hiddenBorrowers
		}
	}
}

#Preview {
	VStack {
		UsersRelationshipView(
			creditors: UserInfoModel.all,
			borrowers: UserInfoModel.all
		)
		.userRelationshipState(.standard)
		
		UsersRelationshipView(
			creditors: UserInfoModel.all,
			borrowers: UserInfoModel.all
		)
		.userRelationshipState(.hiddenBorrowers)
		.frame(width: 200)
		
		UsersRelationshipView(
			creditors: UserInfoModel.all,
			borrowers: UserInfoModel.all
		)
		.userRelationshipState(.hiddenCreditors)
		.frame(width: 1000)
	}
	.controlSize(.mini)
	.userStackSize(3)
}

#Preview {
	VStack {
		UsersRelationshipView(
			creditors: UserInfoModel.all,
			borrowers: UserInfoModel.all
		)
		.userRelationshipState(.standard)
		
		UsersRelationshipView(
			creditors: UserInfoModel.all,
			borrowers: UserInfoModel.all
		)
		.userRelationshipState(.hiddenBorrowers)
		.frame(width: 200)
		
		UsersRelationshipView(
			creditors: UserInfoModel.all,
			borrowers: UserInfoModel.all
		)
		.userRelationshipState(.hiddenCreditors)
		.frame(width: 1000)
	}
	.controlSize(.regular)
	.userStackSize(3)
}
