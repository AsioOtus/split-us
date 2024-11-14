import ILModels
import SwiftUI

public struct UsersRelationshipView: View {
	@Environment(\.controlSize) private var controlSize
	
	let creditors: [UserScreenModel]
	let borrowers: [UserScreenModel]
	
	public init (
		creditors: [UserScreenModel],
		borrowers: [UserScreenModel]
	) {
		self.creditors = creditors
		self.borrowers = borrowers
	}
	
	public var body: some View {
		UserRelationshipContainerView(
			creditorsView: {
				usersView(creditors, "creditor")
			},
			borrowersView: {
				usersView(borrowers, "borrower")
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
		_ users: [UserScreenModel],
		_ type: String
	) -> some View {
		UserHStack(
			users: users
		) { (user, index) in
			UserMinimalView(user: user)
				.avatarOrderIdentifier("\(index.description)-\(type)")
		} truncatingView: { count in
			UserMinimalView(avatar: nil, acronym: "+" + count.description, color: .gray)
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
			creditors: UserScreenModel.all,
			borrowers: UserScreenModel.all
		)
		.userRelationshipState(.standard)
		
		UsersRelationshipView(
			creditors: UserScreenModel.all,
			borrowers: UserScreenModel.all
		)
		.userRelationshipState(.hiddenBorrowers)
		.frame(width: 200)
		
		UsersRelationshipView(
			creditors: UserScreenModel.all,
			borrowers: UserScreenModel.all
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
			creditors: UserScreenModel.all,
			borrowers: UserScreenModel.all
		)
		.userRelationshipState(.standard)
		
		UsersRelationshipView(
			creditors: UserScreenModel.all,
			borrowers: UserScreenModel.all
		)
		.userRelationshipState(.hiddenBorrowers)
		.frame(width: 200)
		
		UsersRelationshipView(
			creditors: UserScreenModel.all,
			borrowers: UserScreenModel.all
		)
		.userRelationshipState(.hiddenCreditors)
		.frame(width: 1000)
	}
	.controlSize(.regular)
	.userStackSize(3)
}
