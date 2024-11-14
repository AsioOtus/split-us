import ComposableArchitecture
import ILLocalization
import Multitool
import SwiftUI

extension AddRemoveContactButton {
	public struct Screen: View {
		let store: StoreOf<AddRemoveContactButton.Reducer>

		public init (store: StoreOf<AddRemoveContactButton.Reducer>) {
			self.store = store
		}

		public var body: some View {
			Group {
				if store.isContact {
					removeButton()
				} else {
					addButton()
				}
			}
			.disabled(store.request.isLoading)
		}
	}
}

private extension AddRemoveContactButton.Screen {
	func addButton () -> some View {
		Button {
			store.send(.onAddContactsButtonTap)
		} label: {
			addLabel()
		}
	}

	@ViewBuilder
	func addLabel () -> some View {
		if case .loading = store.request {
			ProgressView()
		} else {
			ViewThatFits {
				Label(.componentsAddRemoveContactButtonAddContact, systemImage: "person.crop.circle.badge.plus")
					.labelStyle(.titleAndIcon)

				Label(.generalActionAdd, systemImage: "person.crop.circle.badge.plus")
					.labelStyle(.titleAndIcon)
			}
		}
	}
}

private extension AddRemoveContactButton.Screen {
	func removeButton () -> some View {
		Button(role: .destructive) {
			store.send(.onRemoveContactButtonTap)
		} label: {
			removeLabel()
		}
		.tint(.red)
	}

	@ViewBuilder
	func removeLabel () -> some View {
		if case .loading = store.request {
			ProgressView()
		} else {
			ViewThatFits {
				Label(.componentsAddRemoveContactButtonRemoveContact, systemImage: "person.crop.circle.badge.minus")
					.labelStyle(.titleAndIcon)
				
				Label(.generalActionRemove, systemImage: "person.crop.circle.badge.minus")
					.labelStyle(.titleAndIcon)
			}
		}
	}
}
