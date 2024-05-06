import DLModels

public struct TransferInfoModel {
	public let transferUnitInfo: TransferUnit.Info
	public let amounts: [FormattedAmountModel]
	public let creditors: [UserInfoModel]
	public let borrowers: [UserInfoModel]

	public init (
		transferUnitInfo: TransferUnit.Info,
		amounts: [FormattedAmountModel],
		creditors: [UserInfoModel],
		borrowers: [UserInfoModel]
	) {
		self.transferUnitInfo = transferUnitInfo
		self.amounts = amounts
		self.creditors = creditors
		self.borrowers = borrowers
	}
}
