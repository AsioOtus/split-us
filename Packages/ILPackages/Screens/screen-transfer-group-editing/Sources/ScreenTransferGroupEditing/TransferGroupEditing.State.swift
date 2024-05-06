import ComposableArchitecture
import Foundation
import struct IdentifiedCollections.Identified
import Multitool
import ScreenTransferEditing
import DLServices
import DLModels
import TransferComponents
import DLUtils

extension TransferGroupEditing {
	@ObservableState
	public struct State: Equatable {
		let initialTransferGroupContainer: TransferGroup.Container?
		let isLocal: Bool
		let superTransferGroupId: UUID?
		let userGroup: UserGroup
		
		var name: String?
		var note: String?
		var date: Date?
		
		var sharedInfo: SharedInfo
		
		var transferUnits: Loadable<[TransferUnit]> = .successful([])
		var users: Loadable<[User.Compact]> = .initial()
		var sharedCreditorSelectionUsers: Loadable<[User.Compact?]> { users.mapValue { [nil] + $0 } }

		var submitRequest: Loadable<None> = .initial()
		
		@Presents var transferEditing: TransferEditing.State?
		@Presents var transferGroupEditing: Self?

		var transfers: Loadable<Transfers.State> {
			transferUnits.mapValue {
				.init(
					userGroup: userGroup,
					superTransferGroup: initialTransferGroupContainer?.transferGroup,
					transferUnits: $0
				)
			}
		}

		var isCreation: Bool { initialTransferGroupContainer == nil }
		
		public init (
			initialTransferGroupContainer: TransferGroup.Container?,
			isLocal: Bool,
			superTransferGroupId: UUID?,
			userGroup: UserGroup,
			sharedInfo: SharedInfo
		) {
			self.initialTransferGroupContainer = initialTransferGroupContainer
			self.isLocal = isLocal
			self.superTransferGroupId = superTransferGroupId
			self.userGroup = userGroup
			self.sharedInfo = sharedInfo
		}
	}
}

public extension TransferGroupEditing.State {
	static func creation (
		isLocal: Bool = false,
		superTransferGroupId: UUID?,
		userGroup: UserGroup,
		sharedInfo: SharedInfo
	) -> TransferGroupEditing.State {
		.init(
			initialTransferGroupContainer: nil,
			isLocal: isLocal,
			superTransferGroupId: superTransferGroupId,
			userGroup: userGroup,
			sharedInfo: sharedInfo
		)
	}
	
	static func updating (
		initialTransferGroupContainer: TransferGroup.Container,
		isLocal: Bool = false,
		superTransferGroupId: UUID?,
		userGroup: UserGroup
	) -> TransferGroupEditing.State {
		.init(
			initialTransferGroupContainer: initialTransferGroupContainer,
			isLocal: isLocal,
			superTransferGroupId: superTransferGroupId,
			userGroup: userGroup,
			sharedInfo: .init(currency: .eur)
		)
	}
}

extension TransferGroupEditing.State {
	public struct SharedInfo: Equatable {
		public var isEnabled = false
		public var currency: Currency = .eur
		public var creditor: User.Compact?
		public var amountValue: Int?
		public var remainingAmountValue: Int?

		public init (
			isEnabled: Bool = false,
			currency: Currency,
			creditor: User.Compact? = nil,
			amountValue: Int? = nil,
			remainingAmountValue: Int? = nil
		) {
			self.isEnabled = isEnabled
			self.currency = currency
			self.creditor = creditor
			self.amountValue = amountValue
			self.remainingAmountValue = remainingAmountValue
		}

		func set (amountValue: Int) -> Self {
			.init(
				isEnabled: isEnabled,
				currency: currency,
				creditor: creditor,
				amountValue: amountValue,
				remainingAmountValue: remainingAmountValue
			)
		}
	}
}
