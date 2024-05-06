import ILLocalization
import Multitool
import SwiftUI
import DLUtils

public struct AddRemoveContactButton: View {
	let isContact: Bool
	let processingState: Loadable<None>
	let addAction: () -> Void
	let removeAction: () -> Void

	public init (
		isContact: Bool,
		processingState: Loadable<None>,
		addAction: @escaping () -> Void,
		removeAction: @escaping () -> Void
	) {
		self.isContact = isContact
		self.processingState = processingState
		self.addAction = addAction
		self.removeAction = removeAction
	}

	public var body: some View {
		Group {
			if isContact {
				removeButton()
			} else {
				addButton()
			}
		}
		.disabled(processingState.isLoading)
	}
}

private extension AddRemoveContactButton {
	func addButton () -> some View {
		Button(action: addAction, label: addLabel)
			.buttonStyle(.bordered)
	}

	@ViewBuilder
	func addLabel () -> some View {
		if case .processing = processingState {
			ProgressView()
		} else {
			Label(.generalActionAdd, systemImage: "person.crop.circle.badge.plus")
				.labelStyle(.titleAndIcon)
		}
	}
}

private extension AddRemoveContactButton {
	func removeButton () -> some View {
		Button(role: .destructive, action: removeAction, label: removeLabel)
			.buttonStyle(.bordered)
			.tint(.red)
	}

	@ViewBuilder
	func removeLabel () -> some View {
		if case .processing = processingState {
			ProgressView()
		} else {
			Label(.generalActionRemove, systemImage: "person.crop.circle.badge.minus")
				.labelStyle(.titleAndIcon)
		}
	}
}

#Preview {
	VStack(alignment: .leading) {
		AddRemoveContactButton(
			isContact: true,
			processingState: .initial(),
			addAction: { },
			removeAction: { }
		)

		AddRemoveContactButton(
			isContact: false,
			processingState: .initial(),
			addAction: { },
			removeAction: { }
		)

		AddRemoveContactButton(
			isContact: true,
			processingState: .loading(),
			addAction: { },
			removeAction: { }
		)

		AddRemoveContactButton(
			isContact: false,
			processingState: .loading(),
			addAction: { },
			removeAction: { }
		)
	}
	.tint(.cyan)
}
