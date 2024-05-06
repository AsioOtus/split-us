import Dependencies
import Foundation
import DLNetwork
import DLModels

public protocol PTransferService {
	func createTransfer (
		transfer: Transfer.New,
		transferGroupId: UUID?,
		userGroupId: UUID
	) async throws -> Transfer

	func createTransferGroup (
		transferGroupContainer: TransferGroup.New.Container,
		superTransferGroupId: UUID?,
		userGroupId: UUID
	) async throws -> TransferGroup.Container

	func createTransferSplitGroup (
		transferSplitGroup: TransferSplitGroup.New,
		superTransferGroupId: UUID?,
		userGroupId: UUID
	) async throws -> TransferSplitGroup

	func updateTransfer (
		transfer: Transfer.Update
	) async throws -> Transfer

	func updateTransferGroupInfo (
		transferGroupInfo: TransferUnit.Info,
		transferGroupId: UUID
	) async throws -> TransferUnit.Info

	func updateTransferSplitGroup (
		transferSplitGroup: TransferSplitGroup.Update
	) async throws -> TransferSplitGroup

	func replaceTransfer (
		transferGroup: TransferGroup.New,
		transferId: UUID
	) async throws -> TransferGroup

	func deleteTransfer (
		id: UUID
	) async throws

	func deleteTransferGroup (
		id: UUID
	) async throws
}

public struct TransferService: PTransferService {
	@Dependency(\.authenticatedNetworkController) var networkController
}

public extension TransferService {
	func createTransfer (
		transfer: Transfer.New,
		transferGroupId: UUID?,
		userGroupId: UUID
	) async throws -> Transfer {
		try await networkController
			.send(
				Requests.CreateTransfer(
					transfer: transfer,
					superTransferGroupId: transferGroupId,
					userGroupId: userGroupId
				)
			)
			.unfold()
			.transfer
	}

	func createTransferGroup (
		transferGroupContainer: TransferGroup.New.Container,
		superTransferGroupId: UUID?,
		userGroupId: UUID
	) async throws -> TransferGroup.Container {
		try await networkController
			.send(
				Requests.CreateTransferGroup(
					transferGroupContainer: transferGroupContainer,
					superTransferGroupId: superTransferGroupId,
					userGroupId: userGroupId
				)
			)
			.unfold()
			.transferGroupContainer
	}

	func createTransferSplitGroup (
		transferSplitGroup: TransferSplitGroup.New,
		superTransferGroupId: UUID?,
		userGroupId: UUID
	) async throws -> TransferSplitGroup {
		try await networkController.send(
			Requests.CreateTransferSplitGroup(
				body: .init(
					transferSplitGroup: transferSplitGroup,
					superTransferGroupId: superTransferGroupId,
					userGroupId: userGroupId
				)
			)
		)
		.unfold()
		.transferSplitGroup
	}

	func updateTransfer (
		transfer: Transfer.Update
	) async throws  -> Transfer {
		let transfer = try await networkController
			.send(Requests.UpdateTransfer(transfer: transfer))
			.unfold()
			.transfer

		return transfer
	}

	func updateTransferGroupInfo (
		transferGroupInfo: TransferUnit.Info,
		transferGroupId: UUID
	) async throws -> TransferUnit.Info {
		try await networkController
			.send(
				Requests.UpdateTransferGroupInfo(
					transferGroupInfo: transferGroupInfo,
					transferGroupId: transferGroupId
				)
			)
			.unfold()
			.transferInfo
	}

	func updateTransferSplitGroup (
		transferSplitGroup: TransferSplitGroup.Update
	) async throws  -> TransferSplitGroup {
		try await networkController
			.send(
				Requests.UpdateTransferSplitGroup(
					body: .init(
						transferSplitGroup: transferSplitGroup
					)
				)
			)
			.unfold()
			.transferSplitGroup
	}

	func replaceTransfer (
		transferGroup: TransferGroup.New,
		transferId: UUID
	) async throws  -> TransferGroup {
		unimplemented()
	}

	func deleteTransfer (id: UUID) async throws {
		_ = try await networkController
			.send(Requests.DeleteTransfer(transferId: id))
			.unfold()
	}

	func deleteTransferGroup (id: UUID) async throws {
		_ = try await networkController
			.send(Requests.DeleteTransferGroup(transferGroupId: id))
			.unfold()
	}
}

extension TransferService: DependencyKey {
	public static var liveValue: PTransferService {
		TransferService()
	}
}

public extension DependencyValues {
	var transferService: PTransferService {
		get { self[TransferService.self] }
		set { self[TransferService.self] = newValue }
	}
}
