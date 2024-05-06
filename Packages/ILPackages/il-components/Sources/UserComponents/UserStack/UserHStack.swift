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
	@ViewBuilder let userView: (User) -> UserView
	@ViewBuilder let truncatingView: (Int) -> TruncatingView
	
	var visibleUsers: [User] {
		if let userStackSize {
			Array(users[0..<userStackSize])
		} else {
			users
		}
	}
	
	var truncatedCount: Int? {
		userStackSize.map { users.count - $0 }
	}
	
	public  var body: some View {
		OverlappableHStack(spacing: 4) {
			ForEach(visibleUsers, id: \.self) { user in
				userView(user)
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
			users: UserInfoModel.all
		) { user in
			UserMinimalView(initials: user.initials, avatar: user.image)
		} truncatingView: { count in
			UserMinimalView(initials: "+" + count.description, avatar: nil)
		}
		.userStackSize(3)
	}
}
