import DLModels
import ILModels
import ILModelsMappers
import ILUtils
import SwiftUI

public struct UserSummaryView: View {
	let currencyFormatter = NumberFormatter.currency
	
	let userSummary: UserSummary
	let userScreenModelMapper = UserScreenModel.Mapper.default
	
	public init (userSummary: UserSummary) {
		self.userSummary = userSummary
	}
	
	public var body: some View {
		DisclosureGroup {
			ForEach(userSummary.relatedUserAmounts, id: \.self) { userAmounts in
				userView(userAmounts.user, userAmounts.amounts)
			}
		} label: {
			userView(userSummary.user, userSummary.totalAmount)
		}
	}
	
	func userView (_ user: User.Compact, _ amounts: [Amount]) -> some View {
		UserAmountsView {
			UserDetailedView(user: userScreenModelMapper.map(user))
		} amountsView: {
			WrappableHStack(alignment: .trailing) {
				ForEach(amounts, id: \.self) { amount in
					AmountView(currencyFormatter.format(amount))
				}
			}
		}
	}
}
