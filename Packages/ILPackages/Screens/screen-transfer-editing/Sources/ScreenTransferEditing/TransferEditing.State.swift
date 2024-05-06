import AmountComponents
import ComposableArchitecture
import Debug
import Foundation
import Multitool
import DLServices
import DLModels
import DLUtils

extension TransferEditing {
	@ObservableState
	public struct State: Equatable {
		public let initialTransferUnit: TransferUnit?
		public let initialCreditor: User.Compact?
		public let initialRemainingAmountValue: Int?
		public let isLocal: Bool
		public let superTransferGroupId: UUID?
		public let userGroup: UserGroup

		var name: String? = ""
		var note: String? = ""
		var date: Date? = .init()
		var creditor: User.Compact?

		var perItemAmountValueInput: Int? = 100
		var itemCount: Int? = 1
		var totalAmountValue: Int { (perItemAmountValueInput ?? 0) * (itemCount ?? 1) }

		var currency: Currency = .eur
		var remainingAmountValue: Int?

		var submitRequest: Loadable<None> = .initial()

		var users: Loadable<[User.Compact]> = .initial()

		var creditorSelectionUsers: Loadable<[User.Compact?]> { users.mapValue { [nil] + $0 } }
		var borrowerSelectionUsers: Loadable<[User.Compact?]> { users.mapValue { [nil] + $0 } }

		var amountValueSplitInteractor: AmountValueSplitInteractor?
		var isCreation: Bool { initialTransferUnit == nil }

		public init (
			initialTransferUnit: TransferUnit?,
			initialCreditor: User.Compact?,
			initialRemainingAmountValue: Int?,
			isLocal: Bool,
			superTransferGroupId: UUID?,
			userGroup: UserGroup
		) {
			self.initialTransferUnit = initialTransferUnit
			self.initialCreditor = initialCreditor
			self.initialRemainingAmountValue = initialRemainingAmountValue
			self.isLocal = isLocal
			self.superTransferGroupId = superTransferGroupId
			self.userGroup = userGroup
			self.remainingAmountValue = initialRemainingAmountValue

			if let initialCreditor {
				creditor = initialCreditor
			}
		}
	}
}

public extension TransferEditing.State {
	static func creation (
		isLocal: Bool = false,
		superTransferGroupId: UUID?,
		userGroup: UserGroup,
		initialCreditor: User.Compact?,
		remainingAmountValue: Int?
	) -> Self {
		.init(
			initialTransferUnit: nil,
			initialCreditor: initialCreditor,
			initialRemainingAmountValue: remainingAmountValue,
			isLocal: isLocal,
			superTransferGroupId: superTransferGroupId,
			userGroup: userGroup
		)
	}

	static func updating (
		initialTransferUnit: TransferUnit,
		isLocal: Bool = false,
		superTransferGroupId: UUID?,
		userGroup: UserGroup
	) -> Self {
		.init(
			initialTransferUnit: initialTransferUnit,
			initialCreditor: nil,
			initialRemainingAmountValue: nil,
			isLocal: isLocal,
			superTransferGroupId: superTransferGroupId,
			userGroup: userGroup
		)
	}
}
