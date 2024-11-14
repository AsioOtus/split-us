import DLErrors
import ILLocalization
import ILUtils
import ILPreview
import SwiftUI

public struct StandardErrorView <ActionView: View, DefaultView: View>: View {
	let error: Error
	let actionView: ActionView
	let defaultView: (Error) -> DefaultView

	public init (
		error: Error,
		description: LocalizedStringKey? = nil
	) where ActionView == EmptyView, DefaultView == GeneralErrorView<EmptyView> {
		self.error = error
		self.actionView = EmptyView()
		self.defaultView = { _ in
			GeneralErrorView(description: description)
		}
	}

	public init (
		error: Error,
		description: LocalizedStringKey? = nil,
		@ViewBuilder actionView: () -> ActionView
	) where DefaultView == GeneralErrorView<ActionView> {
		let actionView = actionView()

		self.error = error
		self.actionView = actionView
		self.defaultView = { _ in
			GeneralErrorView(description: description) { actionView }
		}
	}

	public init (
		error: Error,
		@ViewBuilder defaultView: @escaping (Error) -> DefaultView
	) where ActionView == EmptyView {
		self.error = error
		self.actionView = EmptyView()
		self.defaultView = defaultView
	}

	public init (
		error: Error,
		@ViewBuilder actionView: () -> ActionView,
		@ViewBuilder defaultView: @escaping (Error) -> DefaultView
	) {
		self.error = error
		self.actionView = actionView()
		self.defaultView = defaultView
	}

	public var body: some View {
		switch error {
		case is OfflineTriggerError:
			OfflineErrorView { actionView }
		default:
			defaultView(error)
		}
  }
}
