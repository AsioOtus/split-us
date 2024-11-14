import ILDesignResources
import SwiftUI

public struct GeneralErrorView <ActionView: View>: View {
	let description: LocalizedStringKey?
	let actionView: ActionView

	public init (description: LocalizedStringKey? = nil) where ActionView == EmptyView {
		self.init(description: description) {
			EmptyView()
		}
	}

	public init (
		description: LocalizedStringKey? = nil,
		@ViewBuilder actionView: () -> ActionView
	) {
		self.description = description
		self.actionView = actionView()
	}

	public var body: some View {
		ContentUnavailableView {
			GeneralErrorLabel()
		} description: {
			if let description {
				Text(description)
			}
		} actions: {
			actionView
		}
	}
}
