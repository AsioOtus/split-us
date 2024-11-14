import ILModels
import ILUtils
import DLModels
import SwiftUI

public struct UserHStack<User, UserView, TruncatingView>: View
where
User: Hashable,
UserView: View,
TruncatingView: View
{
	@Environment(\.userStackSize) private var userStackSize
	
	let users: [User]
	@ViewBuilder let userView: (User, Int) -> UserView
	@ViewBuilder let truncatingView: (Int) -> TruncatingView
	
	var visibleUsers: [User] {
		if let userStackSize {
			Array(users[0..<userStackSize])
		} else {
			users
		}
	}

	var indexedVisibleUsers: [(Int, User)] {
		Array(zip(visibleUsers.indices, visibleUsers))
	}

	var truncatedCount: Int? {
		userStackSize.map { users.count - $0 }
	}
	
	public var body: some View {
		OverlappableHStack(spacing: 2) {
			ForEach(indexedVisibleUsers, id: \.1) { (index, user) in
				userView(user, index)
			}
			
			if let truncatedCount {
				truncatingView(truncatedCount)
			}
		}
	}
}

#Preview {
	VStack {
		UserHStack(
			users: UserScreenModel.all
		) { (user, _) in
			UserMinimalView(avatar: user.image, acronym: user.initials, color: .red)
		} truncatingView: { count in
			UserMinimalView(avatar: nil, acronym: "+" + count.description, color: .green)
		}
		.userStackSize(3)
	}
}
