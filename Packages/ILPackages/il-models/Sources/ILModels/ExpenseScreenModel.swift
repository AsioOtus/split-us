import DLModels
import Foundation

public struct ExpenseScreenModel {
	public let id: UUID
	public let expenseInfo: ExpenseInfo
	public let offlineStatus: OfflineStatus
	public let amounts: [AmountScreenModel]
	public let undistributedAmounts: [AmountScreenModel]
	public let creditors: [UserScreenModel]
	public let borrowers: [ExpenseParticipantScreenModel]

	public init (
		id: UUID,
		expenseInfo: ExpenseInfo,
		offlineStatus: OfflineStatus,
		amounts: [AmountScreenModel],
		undistributedAmounts: [AmountScreenModel],
		creditors: [UserScreenModel],
		borrowers: [ExpenseParticipantScreenModel]
	) {
		self.id = id
		self.expenseInfo = expenseInfo
		self.offlineStatus = offlineStatus
		self.amounts = amounts
		self.undistributedAmounts = undistributedAmounts
		self.creditors = creditors
		self.borrowers = borrowers
	}
}
